NOTE: THIS IS PLACEHOLDER FOR FUTURE RELEASES

# Spek2

Test centric web framework

# INSTALL

cpanm Spek2


# USAGE


## create some http resources

    # GET Users List

    $ mkdir users
    $ touch users/get.txt

    # CREATE User

    $ mkdir -p user/id
    $ touch user/id/post.txt

    # DELETE User

    $ touch user/id/delete.txt


Follow [swat](https://github.com/melezhik/swat) documentation on how to define http resources tests using swat


## run spek

    $ spek


