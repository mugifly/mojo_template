package Example::Controller::Session;
use Mojo::Base 'Mojolicious::Controller';

sub oauth_twitter_redirect {
	my $self = shift;
	
	# Load the helper
	$self->app->plugin('Example::Helper::Login');
	
	# Initialize a instance (Net::OAuth2::Client)
	my $oauth = $self->oauth_client_twitter;
	
	# Redirect to twitter authorize page
	$self->redirect_to($oauth->authorize_url());
}

sub oauth_twitter_callback {
	my $self = shift;
	
	# Load the helper
	$self->app->plugin('Example::Helper::Login');
	
	# Initialize a instance (Net::OAuth2::Client)
	my $oauth = $self->oauth_client_twitter;
	
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
	my $response = $access_token->get('https://api.twitter.com/1/account/verify_credentials.json');
	unless ($response->is_success) {
		$self->flash('message_error','Failed to get the user infomation. Please retry later.');
		$self->redirect_to('/?failed_userinfo');
		return;
	}
	
	# If success ...
	my $profile = Mojo::JSON->decode($response->decoded_content());
	my $user_id = $profile->{id};
	
	#TODO 未実装
	
}

sub logout {
	my $self = shift;
	
	# Clear the session
	$self->session(expires => 1);
	
	# Redirect to top page
	$self->redirect_to('/');
}

1;
