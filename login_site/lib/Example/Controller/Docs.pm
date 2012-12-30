package Example::Controller::Docs;
use Mojo::Base 'Mojolicious::Controller';

# About page
sub about {
	my $self = shift;
	$self->render();
}

# Privacy policy page
sub privacy {
	my $self = shift;
	$self->render();
}

1;
