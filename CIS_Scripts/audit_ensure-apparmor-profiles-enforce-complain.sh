#!/usr/bin/env bash

apparmor_status | grep profiles
# profiles in enfore mode and complain mode should equal profiles loaded

apparmor_status | grep processes
# processes unconfined should equal zero