#!/usr/bin/env bash

    #
    # Versions
    #
    echo "*********************"
    echo "GIT VERSION"
    git --version
    echo "*********************"
    echo "PHP VERSION"
    php --version | grep built
    echo "*********************"
    echo "NGINX VERSION"
    nginx -v
    echo "*********************"
    echo "REDIS VERSION"
    redis-server -v
    echo "*********************"
    echo "MYSQL VERSION"
    dpkg -l 'mysql-server*' | grep "ii.*core"
    #mysql -u root -p -v 
    echo "*********************"
    echo "NODE VERSION"
    nodejs -v
    echo "*********************"
    echo "NPM VERSION"
    npm --version
    echo "*********************"
    echo "GULP VERSION"
    gulp --version
    echo "*********************"
