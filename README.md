# NAME

Spek

# SYNOPSIS

Test centric web framework

# INSTALL

cpanm Spek


# USAGE

## declare http endpoints

To declare http endpoint you should write swat tests:

### GET /users

To get users list ...

    $ mkdir users
    $ touch users/get.txt

### POST /user

To create a new user ...

    $ mkdir -p user
    $ touch user/post.txt

### GET /user

To get user info ...

    $ mkdir -p user/id
    $ touch user/id/get.txt


Follow [swat](https://github.com/melezhik/swat) for full explanation of swat test harness.


## run spek application

    $ spek

    ... you should see:

    HTTP::Server::PSGI: Accepting connections at http://0:5000/

## run swat tests

    # in parallel console

    $ echo 127.0.0.1:5000 > host

    $ swat

    ... you should get an errors like <HTTP/1.0 404 Not Found>
    ... as endpoints are not *defined* yet

    127.0.0.1 - - [16/Mar/2016:09:00:03 +0300] "GET /users HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [16/Mar/2016:09:00:03 +0300] "GET /user/foo HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [16/Mar/2016:09:00:03 +0300] "POST /user HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"

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

It should be [Kelp](https://metacpan.org/pod/Kelp) routes:

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

## And finally create a meta story:

    $ mkdir crud
    $ cat crud/meta.txt

    application should be able
    to perform CRUD operations
    
    $ cat crud/hook.pm

    run_swat_module( POST => '/user' );
    run_swat_module( GET => '/user/id', { id => 'foo' }  );
    run_swat_module( GET => '/users'  );
    
## Rebuild spek app

    In console running spek app:

    $ <CTRL> + <C>
    $ spek

    ... should see:


    reiniting spek app ...
    populate app.pm ...
    populate post /home/vagrant/my/spek-example-app/user ...
    populate get /home/vagrant/my/spek-example-app/user/id ...
    populate get /home/vagrant/my/spek-example-app/users ...
    HTTP::Server::PSGI: Accepting connections at http://0:5000/
    
## Run tests

Now you have a specifi(K)ation simply just running:

    $ swat

    ... should see:

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

# Application introspection

## routes

To inspect all available routes:

    $ spek --routes

## meta stories

To inspect meta stories:

    $ spek --meta

Read [swat](https://github.com/melezhik/swat#meta-stories) documentation to know more about swat meta stories.

# Advanced usage

## handling json responses

Modify Kelp controller

### GET /user/id

    $ cat user/id/get.pm

    my ($self, $id ) = @_;
    {
        id => $id,
        email => $USERS->{$id}->{email} ,
        age => $USERS->{$id}->{age}
    }

Add json handler to swat test:


    $ cat user/id/get.handler

    my $headers   = shift;
    my $body      = shift;
    use JSON;
    $hash = decode_json($body);
    return "$headers\n".("id: $hash->{id}\nemail: $hash->{email}\nage: $hash->{age}");
    

Regenerate spek application


    $ <CTRL> + <C> # to stop running application

    $ spek

    ... should see:

    reiniting spek app ...
    populate app.pm ...
    populate post /home/vagrant/my/spek-example-app/user ...
    populate delete /home/vagrant/my/spek-example-app/user/id ...
    populate get /home/vagrant/my/spek-example-app/user/id ...
    populate get /home/vagrant/my/spek-example-app/users ...
    generate hook for /user/id ...
    inject response handler for get ...
    
Run swat tests

    $ swat

    ... should see:

    ok 7 - 200 / 1 of 1 curl -X GET -k --connect-timeout 20 -m 20 -L -D - '127.0.0.1:5000/user/foo'
    ok 8 - output match 'Content-Type: application/json'
    ok 9 - output match 'id: foo'
    ok 10 - output match 'email: foo@bar'


Read more [swat docs](https://github.com/melezhik/swat#process-http-responses) on how to process
http responses.

To add handlers for other http methods simply create a proper handler file:

### DELETE /user/id

    $ nano user/id/delete.handler # and so on ...

# Author

[Alexey Melezhik](mailto:melezhik@gmail.com)

# Download example spek application

You can upload source code here - [https://github.com/melezhik/spek-example-app](https://github.com/melezhik/spek-example-app)

# See also

* [Kelp](https://metacpan.org/pod/Kelp)

* [swat](https://metacpan.org/pod/swat)
