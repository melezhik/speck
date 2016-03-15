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

    ... you should see HTTP::Server::PSGI: Accepting connections at http://0:5000/

## run swat tests

    # in parallel console

    $ echo 127.0.0.1:5000 > host

    $ swat

    ... you should get an errors like <HTTP/1.0 404 Not Found>
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
    
## refine your tests

### Tests should be swat modules:
        
    $ echo swat_module=1 > users/swat.ini
    $ echo swat_module=1 > user/id/swat.ini
    $ echo swat_module=1 > user/swat.ini

### Some tests should pass http request parameters:


#### POST /user

    $ echo 'curl_params="-d name=foo -d age=30 -d email='foo@bar'"' >> user/swat.ini

### Define expected response:

#### POST /user :
    
    $ echo 'user foo created OK' > user/post.txt

#### GET /users :

    $ cat users/get.txt

    alex: melezhik@gmail.com
    bot: iamarobot@...
    foo: foo@bar

#### GET /user/id

    $ cat user/id/get.txt

    id: foo email: foo@bar

### Some routes should be dynamic

#### GET /user/id

    $ cat user/id/hook.pm

    modify_resource(sub {
        my $r  = shift;
        my $id = module_variable('id');
        s{/id}[/$id] for $r;
        $r;
    })


## And finally create a meta story:

    $ mkdir crud
    $ cat crud/meta.txt

    application should be able
    to perform CRUD operations
    
    $ cat crud/hook.pm

    run_swat_module( POST => '/user' );
    run_swat_module( GET => '/user/id', { id => 'foo' }  );
    run_swat_module( GET => '/users'  );
    
## Rebuild speek app

    In console running speek app:

    $ <CRTL> + <C>
    $ speek

    ... should see:


    reiniting speek app ...
    populate app.pm ...
    populate post /home/vagrant/my/speek-example-app/user ...
    populate get /home/vagrant/my/speek-example-app/user/id ...
    populate get /home/vagrant/my/speek-example-app/users ...
    HTTP::Server::PSGI: Accepting connections at http://0:5000/
    
## Run tests

    $ swat

    ... should see :

    /home/vagrant/.swat/.cache/5738/prove/crud/META/request.t ..
    # @META
    #        application should be able
    #        to perform CRUD operations
    #
    ok 1 - 200 / 1 of 2 curl -X POST -k --connect-timeout 20 -m 20 -d name=foo -d age=30 -d email='foo@bar' -L -D - '127.0.0.1:5000/user'
    ok 2 - output match 'user foo created OK'
    ok 3 - 200 / 1 of 2 curl -X GET -k --connect-timeout 20 -m 20 -L -D - '127.0.0.1:5000/user/foo'
    ok 4 - output match 'id: foo email: foo@bar'
    ok 5 - 200 / 1 of 2 curl -X GET -k --connect-timeout 20 -m 20 -L -D - '127.0.0.1:5000/users'
    ok 6 - output match 'alex: melezhik@gmail.com'
    ok 7 - output match 'bot: iamarobot@...'
    ok 8 - output match 'foo: foo@bar'
    1..8
    ok
    All tests successful.
    Files=1, Tests=8,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.06 cusr  0.00 csys =  0.08 CPU)
    Result: PASS
    







