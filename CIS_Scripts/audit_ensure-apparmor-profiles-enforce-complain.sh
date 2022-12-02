#!/usr/bin/env bash

apparmor_status | grep profiles
# profiles in enforce mode and complain mode should equal profiles loaded

apparmor_status | grep processes
# processes in enforce mode and complain mode should equal processes with profiles defined