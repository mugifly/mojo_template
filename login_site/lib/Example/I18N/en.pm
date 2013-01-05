package Example::I18N::en;
use Mojo::Base 'Example::I18N';
use utf8;

our %Lexicon = (
	site_name => 'Example',
	home => 'Home',
	about => 'About',
	top_page => 'Top page',
	about_page => 'About example',
	privacy_policy => 'Privacy policy',
	regist_and_login => 'Register & Login',
	logout => 'Logout',
	login_with_social_account => 'Login with your social account',
	please_agree => 'Please agree',
	top_guest_welcome_mes => 'Welcome to Example',
	top_guest_read_mes => 'You can start effective Web development, using Mojolicious on Example.',
	top_login => 'Login',
	top_guest_login_mes => 'You can log in using the your social account, on the top right corner.',
);

1;