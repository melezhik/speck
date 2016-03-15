# Speek

Test centric web framework

# INSTALL

cpanm Speek


# USAGE


## create some http endpoints

    # GET Users List

    $ mkdir users
    $ touch users/get.txt

    # CREATE User

    $ mkdir -p user
    $ touch user/post.txt

    # GET User

    $ mkdir -p user/id
    $ touch user/id/get.txt


Follow [swat](https://github.com/melezhik/swat) documentation on how to define http resources tests using swat


## run speek application

    $ speek


## run swat tests

    # in parallel console

    $ swat

    ... got an errors like <HTTP/1.0 404 Not Found>
    ... as you have to implement endpoints

## implement endpoints

### initialize application

app.pm :

    our $USERS = {
        'alex' => {
            'age' => 39,
            'email' => 'melezhik@gmail.com'
        },
        'bot' => {
            'age' => 1000,
            'email' => 'iamarobot@...'
        },
    
    };
    

### populate controllers

It should be Kelp routes:

#### GET users/

users/get.pm :

    my ( $self ) = @_;
    my $list;
    for my $id ( sort keys %$USERS ) {
        $list.="$id: $USERS->{$id}->{email}\n";
    }
    
    $list;

#### GET user/id

user/id/get.pm :

    my ($self, $id ) = @_;
    "id: $id email: ".($USERS->{$id}->{email});
    

#### POST user

user/post.pm

    my ( $self ) = @_;
    $USERS->{$self->param('name')} = {
        email => $self->param('email'),
        age => $self->param('age'),
    };
    
    "user ".($self->param('name'))." created OK"
    
### refine your tests

        




