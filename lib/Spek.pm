package Spek;
our $VERSION = '0.0.8';
1;

__END__

=pod


=encoding utf8


=head1 NAME

Spek


=head1 SYNOPSIS

Test centric web framework


=head1 INSTALL

cpanm Spek


=head1 USAGE


=head2 declare http endpoints

To declare http endpoint you should write swat tests:


=head3 GET /users

To get users list ...

    $ mkdir users
    $ touch users/get.txt


=head3 POST /user

To create a new user ...

    $ mkdir -p user
    $ touch user/post.txt


=head3 GET /user

To get user info ...

    $ mkdir -p user/id
    $ touch user/id/get.txt

Follow L<swat|https://github.com/melezhik/swat> for full explanation of swat test harness.


=head2 run spek application

    $ spek
    
    ... you should see:
    
    HTTP::Server::PSGI: Accepting connections at http://0:5000/


=head2 run swat tests

    # in parallel console
    
    $ echo 127.0.0.1:5000 > host
    
    $ swat
    
    ... you should get an errors like <HTTP/1.0 404 Not Found>
    ... as endpoints are not *defined* yet
    
    127.0.0.1 - - [16/Mar/2016:09:00:03 +0300] "GET /users HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [16/Mar/2016:09:00:03 +0300] "GET /user/foo HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [16/Mar/2016:09:00:03 +0300] "POST /user HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"


=head2 implement endpoints


=head3 initialize application

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


=head3 populate controllers

It should be L<Kelp|https://metacpan.org/pod/Kelp> routes:


=head4 GET users/

users/get.pm :

    my ( $self ) = @_;
    my $list;
    for my $id ( sort keys %$USERS ) {
        $list.="$id: $USERS->{$id}->{email}\n";
    }
    
    $list;


=head4 GET user/id

user/id/get.pm :

    my ($self, $id ) = @_;
    "id: $id email: ".($USERS->{$id}->{email});


=head4 POST user

user/post.pm

    my ( $self ) = @_;
    $USERS->{$self->param('name')} = {
        email => $self->param('email'),
        age => $self->param('age'),
    };
    
    "user ".($self->param('name'))." created OK"


=head2 refine your tests


=head3 Tests should be swat modules:

    $ echo swat_module=1 > users/swat.ini
    $ echo swat_module=1 > user/id/swat.ini
    $ echo swat_module=1 > user/swat.ini


=head3 Some tests should pass http request parameters:


=head4 POST /user

    $ echo 'curl_params="-d name=foo -d age=30 -d email='foo@bar'"' >> user/swat.ini


=head3 Define expected response:


=head4 POST /user :

    $ echo 'user foo created OK' > user/post.txt


=head4 GET /users :

    $ cat users/get.txt
    
    alex: melezhik@gmail.com
    bot: iamarobot@...
    foo: foo@bar


=head4 GET /user/id

    $ cat user/id/get.txt
    
    id: foo email: foo@bar


=head3 Some routes should be dynamic


=head4 GET /user/id

    $ cat user/id/hook.pm
    
    modify_resource(sub {
        my $r  = shift;
        my $id = module_variable('id');
        s{/id}[/$id] for $r;
        $r;
    })


=head2 And finally create a meta story:

    $ mkdir crud
    $ cat crud/meta.txt
    
    application should be able
    to perform CRUD operations
    
    $ cat crud/hook.pm
    
    run_swat_module( POST => '/user' );
    run_swat_module( GET => '/user/id', { id => 'foo' }  );
    run_swat_module( GET => '/users'  );


=head2 Rebuild spek app

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


=head2 Run tests

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


=head1 appliaction introspection


=head2 routes

To inspect all available routes:

    $ spek --routes


=head2 meta stories

To inspect meta stories:

    $ find ./ -name meta.txt -exec tail -v {} \;

Read L<swat|https://github.com/melezhik/swat#meta-stories> documentation to know more about swat meta stories.


=head1 Author

L<Alexey Melezhik|maito:melezhik@gmail.com>


=head1 See also

=over

=item *

L<Kelp|https://metacpan.org/pod/Kelp>



=item *

L<swat|https://metacpan.org/pod/swat>



=back
