#!/usr/bin/env bash

testResult()
{
    if [ "$1" -eq "0" ]; then
        echo "OK"
    else
        echo FAILED $2
    fi
}

    #
    # Versions
    #
    echo "*********************"
    echo "GIT VERSION"
    git --version
    testResult $? "git"
    echo "*********************"
    echo "PHP VERSION"
    php --version | grep "5.6"
    testResult $? "php"
    echo "*********************"
    echo "NGINX VERSION"
    nginx -v
    testResult $? "nginx"
    echo "*********************"
    echo "REDIS VERSION"
    redis-server -v
    testResult $? "redis"
    echo "*********************"
    echo "MYSQL VERSION"
    dpkg -l 'mysql-server*' | grep "ii.*core"
    testResult $? "mysql"
    #mysql -u root -p -v 
    echo "*********************"
    echo "NODE VERSION"
    nodejs -v
    testResult $? "node"
    echo "*********************"
    echo "NPM VERSION"
    npm --version
    testResult $? "npm"
    echo "*********************"
    echo "GULP VERSION"
    gulp --version
    testResult $? "gulp"
    echo "*********************"
    echo "*********************"
    echo "composer VERSION"
    composer --version
    testResult $? "composer"
    echo "*********************"
