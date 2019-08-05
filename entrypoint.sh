#!/bin/bash
set -e


ROOT_PASSWORD=abc123


mkdir -m 0775 -p /var/run/named
chown root:bind /var/run/named


mkdir -m 0775 -p /var/cache/bind
chown root:bind /var/cache/bind


/etc/init.d/webmin start
exec /usr/sbin/named -u bind
