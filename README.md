# LDSHE-Docker

## Table of Contents:
 - [Requirements](#requirements)
 - [Installation](#installation)
 - [Manage the Application](#manage-the-application)

## Requirements:
You need to install both `docker` and `docker-compose` before setup the docker services.

 - [docker](https://docs.docker.com/install/)
 - [docker-compose](https://docs.docker.com/compose/install/)

You may also want to add your non-root user to the `docker` group in order to prevent using `sudo` all the time during the execution of `docker` or `docker-compose` command. To do so, run
```
sudo groupadd docker
sudo usermod -aG docker <your-user>
```

## Installation:
#### Clone the ldshe-docker repo
```
git clone https://github.com/ldshe/ldshe-docker.git ldshe_docker
```

#### Setup the docker services
For the convenience of testing and debugging, a `setup.sh` has been provided for user to
* clone the LDSHE repo (to the `src` folder),
* pull and build the required docker images,
* initial the database schema and
* install all necessary application libraries.

Make sure you have granted the execution right before setup.
```
cd ldshe_docker
chmod u+x setup.sh
./setup.sh
```
Normally, all docker services including

* `nginx` which provides the web service,
* `app` which executes the LDSHE application logic,
* `mysql` which stores the LDSHE application state,
* `cron` which schedules the tasks,
* `echo` which provides the realtime communication,
* `queue` which provides the message queue delivery and
* `redis` which provides temporary storage for message queue

should be up and running after the setup process.

To check the running services, you may run
```
docker-compose ps
```
 for details.

#### More about the `setup.sh` script

By default, the `setup.sh` script will clean install the LDSHE docker services. Other options are also available by applying the following switches:

* `-b` for rebuilding the docker images,
* `-h` for script usage,
* `-i` for clean install the docker services from scratch,
* `-u` for fetching up-to-date LDSHE sources from repo, installing the application libraries and recompiling the assets.

#### Visit the LDSHE site

The LDSHE web application by default is running on the port `80`. You may try to visit the site through http://localhost. Use one of the following demo accounts to log in and play with it:
* admin / admin
* user / user

If your host environment has other service running on the port `80`, you can [change the exposed port](#change-the-exposed-port) before starting the docker services.

## Manage the Application
#### Stop all services
```
docker-compose stop
```
#### Up all services
```
docker-compose up -d
```
#### Change the exposed port
By default, only the port `80` is exposed to the host for listening HTTP requests. If the listening port conflicts with your host settings, you may edit the `docker-compose.yml` file before starting services.

For example, mapping the host port `8080` to the web service port `80`:
```
services:
  nginx:
    image: nginx:1.10.3
    ports:
      - '8080:80'
```

***Any setting changing in `docker-compose.yml` will only be applied after all docker services are stopped and up again.***

#### Regenerate the application keys
##### Regenerate the API key
To regenerate the APP_KEY for LDSHE API services, you can run
```
docker-compose exec app bash -c 'cd api && sed -i -E "s/(APP_KEY=).+/\1$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)/" .env'
```
##### Regenerate the OAuth2 keys
To regenerate the client keys for LDSHE OAuth2 services, you can run
```
docker-compose exec app bash -c "cd api && php artisan passport:install"
```

#### Recompile the static assets
LDSHE make use of [webpack](https://webpack.js.org/) to bundle the static assets (located at `src/ldsv2/assets`). To recompile the assets after changes, you need to run
```
docker-compose exec app bash -c "cd ldsv2 && npm run dev"
```
for one time bundling or
```
docker-compose exec app bash -c "cd ldsv2 && npm run watch"
```
for continuous bundling.

#### Database data
##### Access the data
To access the data through `mysql` client, you can run
```
docker-compose exec mysql bash -c "mysql -uroot ldshev2"
```

##### Dump the data
Since the data is stored in the docker volume named as `mysql-data`, it can only be accessible through the container. You can dump the data by creating a temporary container on the fly like so:
```
docker-compose run --rm  \
    -v `pwd`/sql:/root:rw \
    mysql \
    bash -c "mysqldump -uroot -hmysql ldshev2 > ~/ldshev2.sql"
```
The resulting `ldshev2.sql` file will be stored in the `sql` folder.
