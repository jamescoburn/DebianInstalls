#!/usr/bin/env bash

dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' xserver-xorg* | grep -Pi '\h+installed\b'
