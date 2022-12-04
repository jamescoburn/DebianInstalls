#!/usr/bin/env bash

dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' rsh-client
