package Example::DBSchema;
# Database schema definition for Data::Model

use parent qw/ Data::Model /;
use Data::Model::Schema sugar => 'example';
 
## Column-sugars ##########

column_sugar 'user.id';
 
## Collections (tables) ##########

# Collection: user
install_model user => schema {
	key 'id';
	index 'session_token';
	index 'google_id';
	index 'google_token';
	columns qw/ name session_token google_id google_token /;
	column 'user.id';
};

1;