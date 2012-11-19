package Example::Controller::Bridge;
use Mojo::Base 'Mojolicious::Controller';

use utf8;

# 前処理を行うブリッジ (認証セッションチェックなど)
sub login_check {
	my $self = shift;
	
	# JavaScriptによるアクセスのためのヘッダを追加
	$self->res->headers->add('Access-Control-Allow-Origin', '*');
	
	# Cookieの有効期限をセット
	$self->session(expiration=> 604800);# 604800 = 7day * 24hour * 60min * 60sec
	
	# ユーザ情報ヘルパーをリセット (非ログイン状態をセット)
	#$self->app->helper('ownUserId' => sub { return undef });
	#$self->app->helper('ownUser' => sub { return undef });
	$self->stash(logined => 0);
	
	return 1; # continue after process (そのまま出力を続行)
}

1;