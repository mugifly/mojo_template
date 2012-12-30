use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  VERSION   => '0.01',
  PREREQ_PM => {
	'Mojolicious' => '3.70',
	'Data::Model' => 0,
	'MongoDB' => 0,
	'Net::OAuth2' => 0,
  },
  test      => {TESTS => 't/*.t'}
);
