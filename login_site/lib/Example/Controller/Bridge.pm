package Example::Controller::Bridge;
use Mojo::Base 'Mojolicious::Controller';

use utf8;

# Bridge for pre-processing
sub login_check {
	my $self = shift;
	
	# Add the HTTP header for JavaScript access.
	$self->res->headers->add('Access-Control-Allow-Origin', '*');
	
	# Set the expiration time for session cookie
	$self->session(expiration=> 604800);# 604800 sec = 7day * 24hour * 60min * 60sec
	
	# Reset the User session helper. (state of the guest session)
	$self->app->helper('ownUserId' => sub { return undef });
	$self->app->helper('ownUser' => sub { return undef });
	$self->stash(logined => 0);
	
	# Check a session
	if($self->session('session_token')){ # If user-agent has a session...
		# Find a matching user from the database
		my $user = $self->getUserObj('session_token' => $self->session('session_token'));
		if($user->{isFound}){ # If user-agent is valid user...
			$self->app->helper('ownUserId' => sub { return $user->{id} });
			$self->app->helper('ownUser' => sub { return $user });
			$self->stash(logined => 1);
			return 1;
		}
	}
	
	# If user-agent has not a valid session...
	if($self->current_route eq "topuser"){
		$self->redirect_to('/');
		return 0;
	}
	
	return 1; # Process continues after this.
}

1;