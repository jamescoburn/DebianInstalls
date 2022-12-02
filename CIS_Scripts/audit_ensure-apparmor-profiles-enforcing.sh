#!/usr/bin/env bash

apparmor_status | grep profiles
# profiles loaded should be greater than zero and profiles in complain mode should equal zero

apparmor_status | grep processes
# processes with profiles defined should be greater than zero and unconfined processes should equal zero