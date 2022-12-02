#!/usr/bin/env bash

systemctl is-enabled systemd-timesyncd.service
# Should return 'enabled'

systemctl is-active systemd-timesyncd.service
# Should return 'active'