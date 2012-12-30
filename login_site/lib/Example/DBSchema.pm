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
	index 'twitter_token';
	columns qw/ name twitter_token /;
	column 'user.id';
};

1;