#!/bin/bash

mkdir -p /var/lib/rpm/backup
cp -af /var/lib/rpm/__db* /var/lib/rpm/backup/
rm -f /var/lib/rpm/__db.[0-9][0-9]*
rpm --quiet -qa
rpm --rebuilddb
yum clean all
