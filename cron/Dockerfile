FROM ldshe-php:1.0

MAINTAINER LDSHE Admin

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
        cron \
        supervisor

COPY ./schedules /etc/cron.d/

RUN crontab /etc/cron.d/schedules

COPY ./supervisor.conf /etc/supervisor/conf.d/

CMD /usr/bin/supervisord
