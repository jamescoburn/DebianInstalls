#!/usr/bin/env bash

dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' rsync

# OR

systemctl is-active rsync
# Should return 'inactive'

systemctl is-enabled rsync
# Should return 'masked'
