#!/bin/sh
set -eu

NAMESPACE="dqx0"
SECRET_NAME="dqx0-local-tls"
OUT_DIR="/tmp/dqx0-tls"

mkdir -p "$OUT_DIR"

openssl req -x509 -nodes -newkey rsa:2048 -sha256 -days 825 \
  -keyout "$OUT_DIR/tls.key" \
  -out "$OUT_DIR/tls.crt" \
  -subj "/CN=dqx0 local cert" \
  -addext "subjectAltName=DNS:hello.dqx0,DNS:app.dqx0,DNS:api.dqx0"

kubectl -n "$NAMESPACE" create secret tls "$SECRET_NAME" \
  --cert="$OUT_DIR/tls.crt" \
  --key="$OUT_DIR/tls.key" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "TLS secret updated: ${NAMESPACE}/${SECRET_NAME}"
echo "Certificate: $OUT_DIR/tls.crt"
