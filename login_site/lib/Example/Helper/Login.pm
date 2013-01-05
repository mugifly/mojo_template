package Example::Helper::Login;

use strict;
use warnings;

use base 'Mojolicious::Plugin';

sub register {
	my ($self, $app) = @_;
	
	# OAuth Client for Google
	$app->helper( oauth_client_google =>
		sub {
			return Net::OAuth2::Client->new(
				$app->config()->{oauth_google_key},
				$app->config()->{oauth_google_secret},
				site	=>	'https://accounts.google.com',
				authorize_path	=>	'/o/oauth2/auth',
				access_token_path=>	'/o/oauth2/token',
				scope	=>	'https://www.googleapis.com/auth/userinfo.email',
			)->web_server(redirect_uri => $app->config()->{base_url} .'session/oauth_google_callback');
		}
	);
}

1;