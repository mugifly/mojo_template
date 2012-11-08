package Example::Controller::Session;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub login {
  my $self = shift;

  $self->render(message => '');
}

1;
