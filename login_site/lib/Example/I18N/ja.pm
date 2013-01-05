package Example::I18N::ja;
use Mojo::Base 'Example::I18N';
use utf8;

our %Lexicon = (
	site_name => 'Example',
	home => 'ホーム',
	about => '当サイトについて',
	top_page => 'トップページ',
	about_page => 'exampleについて',
	privacy_policy => 'プライバシーポリシー',
	regist_and_login => '新規登録 & ログイン',
	login_with_social_account => 'ソーシャルアカウントでログイン',
	please_agree => 'ご同意ください',
	top_guest_welcome_mes => 'Exampleへようこそ。',
	top_guest_read_mes => 'ExampleでMojoliciousを使った効率的なWeb開発をスタートできます。',
	top_login => 'ログイン',
	top_guest_login_mes => '右上のリンクから、お手持ちのソーシャルアカウントで今すぐログイン。',
);

1;