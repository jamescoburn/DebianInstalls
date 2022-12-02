#!/usr/bin/env bash

dpkg-query -s apport > /dev/null 2>&1 && grep -Psi -- '^\h*enabled\h*=\h*[^0]\b' /etc/default/apport
# Nothing should be returned

systemctl is-active apport.service | grep '^active'
# Nothing should be returned