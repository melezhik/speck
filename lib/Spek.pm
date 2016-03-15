package Spek;
our $VERSION = v0.0.1;
1;

__END__

=pod


=encoding utf8

NOTE: THIS IS PLACEHOLDER FOR FUTURE RELEASES


=head1 speck

Test centric web framework


=head1 INSTALL

cpanm Spek


=head1 USAGE


=head2 create some http resources

    # GET Users List
    
    $ mkdir users
    $ touch users/get.txt
    
    # CREATE User
    
    $ mkdir -p user/id
    $ touch user/id/post.txt
    
    # DELETE User
    
    $ touch user/id/delete.txt

Follow L<swat|https://github.com/melezhik/swat> documentation on how to define http resources tests using swat


=head2 run spek

    $ spek
