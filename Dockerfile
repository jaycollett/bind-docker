
FROM ubuntu:18.04 as add-apt-repos

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -q -y gnupg
RUN apt-key adv --fetch-keys http://www.webmin.com/jcameron-key.asc
RUN echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list

FROM ubuntu:18.04

MAINTAINER Jay Collett <jay@jaycollett.com>

ENV BIND_VERSION=9.11.3
ENV WEBMIN_VERSION=1.920

COPY --from=add-apt-repos /etc/apt/trusted.gpg /etc/apt/trusted.gpg
COPY --from=add-apt-repos /etc/apt/sources.list /etc/apt/sources.list

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes

RUN apt-get -q -y update
RUN apt-get -q -y install gnupg

RUN apt-get install -q -y bind9=1:${BIND_VERISON}* bind9-host=1:${BIND_VERSION}* dnsutils
RUN apt-get install -q -y webmin=${WEBMIN_VERSION}*

RUN apt-get -q -y autoremove
RUN apt-get -q -y clean && rm -rf /var/lib/apt/lists/*

EXPOSE 53/udp 53/tcp 10000/tcp

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

RUN chown -R bind:bind /var/lib/bind

COPY bindconf/* /etc/bind/
COPY binddata/* /var/lib/bind/

ENTRYPOINT ["/entrypoint.sh"]
