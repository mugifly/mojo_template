package Example::Controller::Top;
use Mojo::Base 'Mojolicious::Controller';

# Toppage for guest
sub guest {
	my $self = shift;
	if ( $self->ownUserId() ne "" ) { $self->redirect_to("/top"); return; }
	
	if(defined($self->flash("message_error"))){
		$self->stash("message_error", $self->flash("message_error"));
	}
	
	my $iter = $self->app->db->get(user => {where => ['google_token' => "aaa"]});
	
	$self->render();
}

# Toppage for login user
sub user {
	my $self = shift;
	$self->render();
}

1;
