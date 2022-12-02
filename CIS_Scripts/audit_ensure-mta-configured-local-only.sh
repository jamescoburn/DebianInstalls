#!/usr/bin/env bash

ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s'
# Nothing should be returned, but needs to be worked on