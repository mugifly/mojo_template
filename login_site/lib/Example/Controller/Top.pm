package Example::Controller::Top;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub top {
  my $self = shift;

  $self->render(
    message => 'Welcome to the Mojolicious real-time web framework!');
}

1;
