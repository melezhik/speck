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

    $ mkdir -p user/id
    $ touch user/id/post.txt

    # DELETE User

    $ touch user/id/delete.txt


Follow [swat](https://github.com/melezhik/swat) documentation on how to define http resources tests using swat


## run speek application

    $ speek


## run swat tests

    # in parallel console

    $ swat

    ... got an errors like <HTTP/1.0 404 Not Found>
    ... as you have to impliment endpoints

    HTTP::Server::PSGI: Accepting connections at http://0:5000/
    127.0.0.1 - - [15/Mar/2016:13:36:45 +0300] "DELETE /user/id HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [15/Mar/2016:13:36:46 +0300] "DELETE /user/id HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [15/Mar/2016:13:36:50 +0300] "POST /user/id HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [15/Mar/2016:13:36:51 +0300] "POST /user/id HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [15/Mar/2016:13:36:55 +0300] "GET /foo HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [15/Mar/2016:13:36:56 +0300] "GET /foo HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [15/Mar/2016:13:37:00 +0300] "GET /users HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    127.0.0.1 - - [15/Mar/2016:13:37:01 +0300] "GET /users HTTP/1.1" 404 20 "-" "curl/7.47.0-DEV"
    

## impliment endpoints




