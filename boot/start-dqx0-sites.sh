#!/bin/sh
set -eu

PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"

if command -v colima >/dev/null 2>&1; then
  colima start >/dev/null 2>&1 || true
fi

if command -v docker >/dev/null 2>&1; then
  docker context use colima >/dev/null 2>&1 || true
fi

cd /Users/dqx0/dqx0-sites
/usr/local/bin/docker compose up -d >/tmp/dqx0-sites-start.log 2>&1 || true
