package Data::Model::Driver::MongoDB;

################################################################
# Data::Model::Driver::MongoDB
# https://github.com/ytnobody/Data-Model-Driver-MongoDB/
# commit: 9df76dda850a9ca23fe58619d881e973f1172a04
################################################################
# (C) ytnobody <ytnobody@gmail.com>
# This library is free software; you can redistribute it and/or modify it　under the same terms as Perl itself.

use strict;
use warnings;
use parent qw/ Data::Model::Driver /;
our $VERSION = '0.01';

use MongoDB;
use Carp ();
$Carp::Internal{ (__PACKAGE__) } = 1;

sub init {
    my $self = shift;
    my @attr = qw/
        host w wtimeout auto_reconnect auto_connect timeout
        username password db_name query_timeout find_master port
        left_host left_port right_host right_port
    /;
    $self->{ mongodb_config } = {};
    for ( @attr ) {
        $self->{ mongodb_config }->{ $_ } = delete $self->{ $_ } if $self->{ $_ };
    }
    $self->{ mongodb_connection } = $self->_mongodb_connect( %{ $self->{ mongodb_config } } );
    Carp::confess 'you must give \'db\' attribute for instantiate '.__PACKAGE__ unless defined $self->{ db };
}

sub _mongodb_connect {
    my $self = shift;
    my %conf = @_;
    MongoDB::Connection->new( %conf );
}

sub connector { shift->{ mongodb_connection } }

sub _fetch {
    my ( $self, $schema, $query, $multiple ) = @_;
    my $db = $self->{ db };
    my $collection = $schema->model;
    my @res = $multiple ? ( $self->connector->$db->$collection->find( $query->{ where } )->all )
                        : ( $self->connector->$db->$collection->find_one( $query ) )
    ;
    for ( @res ) {
        next unless $_->{ _id };
        $_->{ $schema->{ key }->[0] } = $_->{ _id }->to_string ;
    }
    my $i = 0;
    my $iter = sub {
        return unless defined $res[ $i ];
        $i++;
        $res[ $i - 1 ]; 
    };
    my $x = $iter->();
    return unless $x->{ _id };
    $i = 0;
    return $multiple ? ( $iter, { end => sub { undef @res } } ) : $res[0];
}

sub _create_data {
    my ( $self, $schema ) = @_;
    my $db = $self->{ db };
    my $collection = $schema->model;
    $self->connector->$db->$collection->insert( {} );
}

sub _update {
    my ( $self, $schema, $query, $columns ) = @_;
    my $db = $self->{ db };
    my $collection = $schema->model;
    $self->connector->$db->$collection->update( $query, $columns );
}

sub _remove_data {
    my ( $self, $schema, $query ) = @_;
    my $db = $self->{ db };
    my $collection = $schema->model;
    $self->connector->$db->$collection->remove( $query );
}


sub lookup {
    my ( $self, $schema, $id ) = @_;
    $self->_fetch( $schema, { $schema->{ key }->[0] => $id->[0] } );
}

sub lookup_multi {
    my ( $self, $schema, $ids ) = @_;
    my %res;
    $res{ $_->[0] } = $self->_fetch( $schema, { $schema->{ key }->[0] => $_->[0] } ) for @{ $ids };
    return \%res;
}

sub get {
    my ( $self, $schema, $id, $query ) = @_;
    $self->_fetch( $schema, $query, 1 );
}

sub set {
    my ( $self, $schema, $prikey, $columns ) = @_;
    my $oid = $self->_create_data( $schema );
    $columns->{ $schema->{ key }->[0] } = $oid->to_string;
    $self->_update( $schema, { _id => $oid }, $columns );
    $self->_fetch( $schema, { _id => $oid } );
}

sub delete {
    my ( $self, $schema, $prikey ) = @_;
    $self->_remove_data( $schema, { _id => MongoDB::OID->new( value => $prikey->[0] ) } );
}

sub update {
    my ( $self, $schema, $prikey_old, $prikey_new, $clumns_old, $columns_new, $columns_backup ) = @_;
    $self->_update( $schema, { _id => MongoDB::OID->new( value => $prikey_old->[0] ) }, $columns_new );
}

sub replace {
    Carp::croak "The 'replace' method is not supported by 'Data::Model::Driver::MongoDB'.";
}

1;
__END__

=head1 NAME

Data::Model::Driver::MongoDB - storage driver of Data::Model for MongoDB

=head1 SYNOPSIS

  ### your schema class
  package Oreore::Schema;
  use parent qw/ Data::Model /;
  use Data::Model::Schema;
  
  install_model book => schema {
      key 'id';
      columns qw/ id name author price genre note /;
  };
  
  1;

  ### and use it
  use Oreore::Schema;
  use Data::Model::Driver::MongoDB;
  
  my $mongo_db = Data::Model::Driver::MongoDB->new( 
      host => 'localhost',
      port => 25252,
      db => 'my_database',
  );
  
  my $schema = Oreore::Schema->new;
  $schema->set_base_driver( $mongo_db );

  my $devils_dict = $schema->set( book => { 
      name => "Devil's dictionary",
      author => "Ambrose Bierce",
      price => 700, # <- 700 yen
      genre => "essay",
      note => "Virtuoso of short-story who called reincarnation of Poe were represent modern-civilization by edgy satire and biting irony.",
  } );

  my $id = $devils_dict->id;
  
  my $book = $schema->lookup( book => $id );
  
  my $iter = $schema->get( book => { where => [ genre => 'novel' ] } );
  while ( $book = $iter->next ) {
      print $book->name." / price:". $book->price. "\n";
  }

=head1 DESCRIPTION

Now, it's developing. Some undefined logic is there.

=head1 DIFFERENCE OF USAGE

D::M::D::MongoDB asks to you compliant to some limitation.

There are attributable to MongoDB specification.

=head2 PRIMARY KEY

You can not *SET* or *WRITE* or *OVERWRITE* value to 1st primary-field. 
Value in primary-field is set by MongoDB automatically when you set a data into MongoDB.

For example. Following code is not works as expected.

 my $c = MySchema->new;
 my $mongodb = Data::Model::Driver::MongoDB->new( ... );
 $c->set_base_driver( $mongodb );
 my $row = $c->set( people => 'people123456' => { name => 'john', age => 29 } );
 print $row->id; # like '4dc7b39b73f7b47844000005'

It means, primary-field is read-only and auto-identified.

=head2 "where" SECTION OF get() METHOD

Searching with range of values is not works.

For example. Following code is not works as expected.

 my @rows = $c->get( people => { where => [ age => { '>' => 20 } ] } );

=head1 UNSUPPORTED FUNCTIONS

=over 

=item get_multi

=item delete_multi

=item set_multi

=item replace

=back

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
