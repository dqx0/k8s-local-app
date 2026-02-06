#!/bin/sh
# Ensure loopback alias for local scoped DNS resolver zone.
if ! /sbin/ifconfig lo0 | /usr/bin/grep -q '10\.0\.0\.1'; then
  /sbin/ifconfig lo0 alias 10.0.0.1 up
fi
