#!/usr/bin/env bash

grep -Eq '^root:\$[0-9]' /etc/shadow || echo "root is locked"