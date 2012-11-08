package Example;
use Mojo::Base 'Mojolicious';

use MongoDB;
use Data::Model;
use Data::Model::Driver::MongoDB;

use Example::DBSchema;

# This method will run once at server start
sub startup {
	my $self = shift;
	
	# Documentation browser under "/perldoc"
	$self->plugin('PODRenderer');
	
	# ルータの初期化
	my $r = $self->routes;
	
	# ネームスペースのセット
	$r->namespace('Example::Controller');
	
	# 設定のロード
	my $conf = $self->plugin('Config',{file => 'config/config.conf'});
	
	# Cookieの暗号化キーをセット
	$self->secret('Example'.$conf->{secret});
	
	# データベースの準備
	my $mongoDB = Data::Model::Driver::MongoDB->new( 
		host => 'localhost',
		port => 27017,
		db => 'Example',
	);
	my $schema = Example::DBSchema->new;
	$schema->set_base_driver($mongoDB);
	
	# データベースヘルパーのセット
	$self->attr(db => sub { return $schema; });
	$self->helper('db' => sub { shift->app->db });
	
	# データベースモデルのセット
	
	# ユーザ情報ヘルパーのセット
	$self->helper('ownUserId' => sub { return undef });
	$self->helper('ownUser' => sub { return undef });
	$self->stash(logined => 0);
	
	# 前処理を行うブリッジ (認証セッションチェックなど)
	$r = $r->bridge->to('bridge#login_check');
	
	# 通常のルート
	$r->route('')->to('top#top',);
	$r->route('/login')->to('session#login');
	$r->route('/user/edit')->to('user#edit',);
	$r->route('/logout')->to('session#logout');
}

1;
