mojo_template
====

Templates for quickly web development, with perl + Mojolicious.

This project has just launched development (now).

This project is not official.

***

* perl 5.10 (or later)

* Mojolicious 3.70 (or later)

* MongoDB

* Data::Model + Data::Model::Driver::MongoDB

* Twitter Bootstrap

* etc...

***

## Notice

If you have never used Mojolicious, I recommend you to begin application development with Mojolicious::Lite,
 and refer to [official tutorials](http://mojolicio.us/perldoc/Mojolicious/Lite).
 
Because this template is not official and can't guarantee quality.

## Include templates

* login_site
	
	The website that can login using OAuth2.

## Usage

### Required

perl 5.10 (or later)

and other modules.

	$ cpan Mojolicious
	$ cpan Data::Model
	$ cpan MongoDB
	$ cpan Net::OAuth2

### Usage

Please execute the following commands with a console:

	$ git clone git://github.com/mugifly/mojo_template.git
	$ cd mojo_template/login_site/
	$ morbo script/example 

Then, let's access with browser: http://localhost:3000/

The "morbo" command is launching the "Mojo::Server::Morbo" daemon, with Application (script/example).
 (["Mojo::Server::Morbo"](http://mojolicio.us/perldoc/Mojo/Server/Morbo) is a daemon for development. It is bundled with the Mojolicious framework.)

Enjoy the web development! with perl + Mojolicious :)
please refer to: http://mojolicio.us/perldoc 
 ([Japanse translation](https://github.com/yuki-kimoto/mojolicious-guides-japanese/wiki))

### How to change the app name (Appname: "HogeHoge")

You can use the bundled script (rename_batch.pl).

Please execute the following commands with a console:

	$ chmod u+x rename_batch.pl
	$ ./rename_batch.pl
	Please enter your new app name ...: HogeHoge
	Will this do...? [y/n]: y
	...
	Complete. let's enjoy!

## Libraries and materials

Many thanks!!

### Mojolicious
https://github.com/kraih/mojo

### Data::Model
http://github.com/yappo/p5-Data-Model/

### Data::Model::Driver::MongoDB
https://github.com/ytnobody/Data-Model-Driver-MongoDB/

	(C) ytnobody <ytnobody@gmail.com>
	This library is free software; you can redistribute it and/or modify it　under the same terms as Perl itself.

### Net::OAuth2
https://github.com/keeth/Net-OAuth2

### Bootstrap (Twitter Bootstrap)
https://github.com/twitter/bootstrap

	Copyright 2012 Twitter, Inc.
	Apache License 2.0 https://github.com/twitter/bootstrap/blob/master/LICENSE

### jQuery - v1.8.3
http://jquery.com/

	Copyright 2012 jQuery Foundation and other contributors. http://jquery.com/
	MIT License	https://github.com/jquery/jquery/blob/master/MIT-LICENSE.txt

### Glyphicons Free
http://glyphicons.com/

	GLYPHICONS FREE are released under the Creative Commons Attribution 3.0 Unported (CC BY 3.0).
	The GLYPHICONS FREE can be used both commercially and for personal use, 
	but you must always add a link to glyphicons.com in a prominent place (e.g. the footer of a website), 
	include the CC-BY license and the reference to glyphicons.com on every page using GLYPHICONS.

## Authors and license
Masanori Ohgita (http://ohgita.info/).

This template is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

Thanks, Perl Mongers & CPAN authors.

