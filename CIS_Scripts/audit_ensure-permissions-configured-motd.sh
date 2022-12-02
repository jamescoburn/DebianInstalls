#!/usr/bin/env bash

stat -L /etc/motd
# Should be 0644:root:root or 'No such file or directory'
