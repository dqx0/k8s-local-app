#!/bin/sh
set -eu

PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Cluster start/install is handled separately.
# This script is intended to be managed by launchd.
kubectl cluster-info >/dev/null 2>&1 || exit 0
kubectl get ns ingress-nginx >/dev/null 2>&1 || exit 0

# Wait briefly for controller service before forwarding.
for _ in 1 2 3 4 5 6 7 8 9 10; do
  kubectl -n ingress-nginx get svc ingress-nginx-controller >/dev/null 2>&1 && break
  sleep 2
done

exec kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 80:80 443:443 --address 127.0.0.1
