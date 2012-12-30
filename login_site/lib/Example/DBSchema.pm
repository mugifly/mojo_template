package Example::DBSchema;
# Database schema definition for Data::Model

use parent qw/ Data::Model /;
use Data::Model::Schema;
 
install_model user => schema {
	key 'id';
	columns qw/ id name email pw /;
};

1;