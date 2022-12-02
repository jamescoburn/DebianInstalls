#!/usr/bin/env bash

find /etc/systemd -type f -name '*.conf' -exec grep -Ph '^\h*(NTP|FallbackNTP)=\H+' {} +
# Output as follows:
# NPT=<space_seporated_list_of_servers>
# FallbackNTP=<space_seporated_list_of_servers>