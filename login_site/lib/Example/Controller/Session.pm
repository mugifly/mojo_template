package Example::Controller::Session;
use Mojo::Base 'Mojolicious::Controller';

sub oauth_google_redirect {
	my $self = shift;
	
	# Load the helper
	$self->app->plugin('Example::Helper::Login');
	
	# Initialize a instance (Net::OAuth2::Client)
	my $oauth = $self->oauth_client_google;
	
	# Redirect to twitter authorize page
	$self->redirect_to($oauth->authorize_url());
}

sub oauth_google_callback {
	my $self = shift;
	
	# Load the helper
	$self->app->plugin('Example::Helper::Login');
	
	# Initialize a instance (Net::OAuth2::Client)
	my $oauth = $self->oauth_client_google;
	
	# Get a access token object
	my $access_token;
	eval {
		$access_token = $oauth->get_access_token($self->param('code'));
	};
	if($@){
		$self->flash('message_error','Failed the OAuth authorization. Please retry.');
		$self->redirect_to('/?token_invalid');
		return;
	}
	
	# Get a user infomation
	my $response = $access_token->get('https://www.googleapis.com/oauth2/v1/userinfo');
	unless ($response->is_success) {
		$self->flash('message_error','Failed to get the user infomation. Please retry later.');
		$self->redirect_to('/?failed_userinfo');
		return;
	}
	
	# If success ...
	my $profile = Mojo::JSON->decode($response->decoded_content());
	my $user_id = $profile->{email};
	
	# Insert/Update user to DB
	my $row = $self->db->find_or_create(
		user => {
           google_id => $user_id,
		} => {
			name => $user_id,
			google_id => $user_id,
			google_token => $access_token->{access_token},
			session_token => $access_token->{access_token},
		}
	);
	
	# Save token to session cookie
	$self->session('session_token', $access_token->{access_token});
	
	$self->redirect_to('/top');
}

sub logout {
	my $self = shift;
	
	# Clear the session
	$self->session(expires => 1);
	
	# Redirect to top page
	$self->redirect_to('/');
}

1;
