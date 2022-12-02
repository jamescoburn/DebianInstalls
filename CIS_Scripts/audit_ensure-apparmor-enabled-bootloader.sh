#!/usr/bin/env bash

grep "^\s*linux" /boot/grub/grub.cfg | grep -v "apparmor=1"
# Nothing should be returned

grep "^\s*linux" /boot/grub/grub.cfg | grep -v "security=apparmor"
# Nothing should be returned