FROM ubuntu:latest
MAINTAINER elpa-mirror-svc@ccbar.us

#Install Dependencies
RUN apt-get update
RUN apt-get -y install cron git make tar emacs wget rsync

WORKDIR /elpa
COPY Makefile /elpa/Makefile
COPY crontab /etc/cron.d/elpa-cron
RUN chmod 0644 /etc/cron.d/elpa-cron

RUN touch /var/log/elpa-cron.log


# Run the command on container startup
CMD cron && tail -f /var/log/elpa-cron.log
