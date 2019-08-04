FROM ubuntu:18.04

MAINTAINER Jay Collett <jay@jaycollett.com>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -q -y update
RUN apt-get -q -y gnupg
RUN apt-key adv --fetch-keys http://www.webmin.com/jcameron-key.asc
RUN echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
RUN apt-get -q -y update

ENV BIND_USER=bind 
ENV BIND_VERSION=9.11.3 
ENV WEBMIN_VERSION=1.9 

RUN apt-get install -q -y bind9=1:${BIND_VERISON}* bind9-host=1:${BIND_VERSION}* dnsutils
RUN apt-get install -q -y webmin-${WEBMIN_VERSION}*

RUN apt-get -q -y autoremove
RUN apt-get -q -y clean && rm -rf /var/lib/apt/lists/*


EXPOSE 53/udp 53/tcp 10000/tcp

#ENTRYPOINT ["/run_dhcpd.sh"]