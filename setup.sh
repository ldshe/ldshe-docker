#!/bin/bash

usage() {
    msg=$(cat <<EOF

LDSHE docker services setup script

Usage: setup [OPTION]
    OPTION
        -b    rebuild the docker images
        -h    help
        -i    clean install
        -u    fetch up-to-date LDSHE sources from repo, install the application libraries and recompile the assets
EOF
)
    echo "$msg"
}

argsCheck() {
    while getopts ":hibu" opt; do
        case "$opt" in
            "h")
                usage
                exit 0;
                ;;
            "i")
                cleanInstall
                exit 0;
                ;;
            "b")
                stop
                buildImg
                start
                exit 0;
                ;;
            "u")
                update
                exit 0;
                ;;
            "?")
                echo "Unknown option $OPTARG"
                usage
                exit 0;
                ;;
            ":")
                echo "No argument value for option $OPTARG"
                usage
                exit 0;
                ;;
            *)
                echo "Unknown error while processing options"
                exit 0;
                ;;
        esac
    done

    if [ $OPTIND -eq 1 ]; then
        cleanInstall
    fi

    shift $(($OPTIND - 1))
}

cloneRepo() {
    echo
    echo "Cloning LDSHE repo..."
    echo
    if [ -d "src" ]; then
      rm -rf src
    fi
    mkdir src
    pushd src
    git init
    git remote add -f origin https://github.com/ldshe/ldshe.git
    git checkout master
    popd
}

pullRepo() {
    echo
    echo "Fetching source codes..."
    echo
    pushd src
    git fetch origin master
    git reset --hard origin/master
    git checkout master
    popd
}

rmInstallIdx() {
    rm -f src/install/index.php
}

updateConf() {
    if [ -f "src/api/.env" ]; then
        appKey=`sed -n -e "/APP_KEY/ s/.*\= *//p" "src/api/.env"`
    fi
    copyConf
    if  [ ! -z "$appKey" ]; then
        sed -i -E "s/(APP_KEY=)(.+)/\1$appKey/" "src/api/.env"
    fi
}

copyConf() {
    yes | cp config/app/.env.api src/api/.env
    yes | cp config/app/.env.echo src/echo/.env
    yes | cp config/app/.env.ldsv2 src/ldsv2/.env
    yes | cp config/app/.env.users src/users/.env
}

buildImg() {
    echo
    echo "Building docker images..."
    echo
    docker build -t ldshe-php:1.0 php
    docker-compose build --build-arg uid=$(id -u) app
    docker-compose build cron
}

initDB() {
    echo
    echo "Creating database & tables..."
    echo
    docker-compose up -d mysql

    while ! docker-compose exec mysql mysqladmin -uroot -hmysql ping --silent &> /dev/null ; do
        echo "Waiting for database connection..."
        sleep 2
    done

    echo "Executing SQL statements..."
    docker-compose run --rm \
        -v `pwd`/sql/init.sql:/root/init.sql:ro \
        -v `pwd`/sql/seeds.sql:/root/seeds.sql:ro \
        -v `pwd`/src/install/install/includes/sql.sql:/root/userspice.sql:ro \
        mysql \
        bash -c \
        "mysql -uroot -hmysql < /root/init.sql &&\
         mysql -uroot -hmysql ldshev2 < /root/userspice.sql &&\
         mysql -uroot -hmysql ldshev2 < /root/seeds.sql"
}

installLib() {
    echo
    echo "Installing application libraries and recompile the assets..."
    echo
    docker-compose run --rm app bash -c \
        "composer install -d ./api &&\
         npm install --prefix ./echo &&\
         composer install -d ./ldsv2 &&\
         npm install --prefix ./ldsv2 &&\
         npm run dev --prefix ./ldsv2 &&\
         composer install -d ./users &&\
         php api/artisan migrate"
}

start() {
    echo
    echo "Starting docker services..."
    echo
    docker-compose up -d
}

stop() {
    echo
    echo "Stopping docker services..."
    echo
    docker-compose stop
}

cleanInstall() {
    read -p "You are going to clean install the LDSHE docker services. Continue (Y/N)? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        :
    else
        exit 0;
    fi
    stop
    cloneRepo
    rmInstallIdx
    copyConf
    buildImg
    initDB
    installLib
    start
    echo
    echo "Docker services for LDSHE are now up and ready!"
    echo
}

update() {
    updateConf
    pullRepo
    rmInstallIdx
    installLib
    echo
    echo "LDSHE application is updated!"
    echo
}

argsCheck "$@"
