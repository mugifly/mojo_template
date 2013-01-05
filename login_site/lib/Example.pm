package Example;
use Mojo::Base 'Mojolicious';

use MongoDB;
use Data::Model;
use Data::Model::Driver::MongoDB;

use Example::DBSchema;

use Net::OAuth2::Client;

# This method will run once at server start
sub startup {
	my $self = shift;
	
	# Documentation browser under "/perldoc"
	$self->plugin('PODRenderer');
	
	# Load the plugin for Internationalization
	$self->plugin('I18N' => {default => 'en', namespace => 'Example::I18N', support_url_langs => [qw(ja en)]});
	
	# Initialize router
	my $r = $self->routes;
	
	# Set the namespace of controller
	$r = $r->namespaces(['Example::Controller']);
	
	# Read the app configuration
	my $conf = $self->plugin('Config',{file => 'config/config.conf'});
	
	# Set the secret key to session cookie
	$self->secret('Example'.$conf->{secret});
	
	# Prepare the database
	my $mongoDB = Data::Model::Driver::MongoDB->new( 
		host =>	$conf->{db_host} || 'localhost',
		port =>	$conf->{db_port} || '27017',
		db =>	$conf->{db_name} || 'example',
	);
	my $schema = Example::DBSchema->new;
	$schema->set_base_driver($mongoDB);
	
	# Set the database helper
	$self->attr(db => sub { return $schema; });
	$self->helper('db' => sub { shift->app->db });
	
	# Bridge for pre-processing (authorization)
	$r = $r->bridge->to('bridge#login_check');
	
	# Routes
	$r->route('')->to('top#guest',);
	$r->route('/top')->to('top#user',);
	
	$r->route('/docs/about')->to('docs#about',);
	$r->route('/docs/privacy')->to('docs#privacy',);
	
	$r->route('/session/oauth_google_redirect')->to('session#oauth_google_redirect');
	$r->route('/session/oauth_google_callback')->to('session#oauth_google_callback');
	$r->route('/session/logout')->to('session#logout');
}

1;
