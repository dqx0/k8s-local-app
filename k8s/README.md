# dqx0 k8s

## 1) Start Colima with Kubernetes

```bash
colima start --kubernetes --cpu 4 --memory 6 --disk 30
kubectl cluster-info
```

## 2) Build APP/API images into Colima runtime

```bash
cd /Users/dqx0/dqx0-sites
docker build -t dqx0-sites-app:latest ./app
docker build -t dqx0-sites-api:latest ./api
```

## 3) Deploy

```bash
kubectl apply -k /Users/dqx0/dqx0-sites/k8s
kubectl -n dqx0 get pods,svc,ingress
```

## 4) Keep local forwarding up (127.0.0.1:80/443 -> ingress-nginx)

```bash
cp /Users/dqx0/dqx0-sites/boot/com.dqx0.k8s-ingress-forward.plist ~/Library/LaunchAgents/com.dqx0.k8s-ingress-forward.plist
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.dqx0.k8s-ingress-forward.plist 2>/dev/null || true
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.dqx0.k8s-ingress-forward.plist
launchctl enable gui/$(id -u)/com.dqx0.k8s-ingress-forward
```

## 5) Enable HTTPS on ingress

```bash
/Users/dqx0/dqx0-sites/k8s/create-local-tls-secret.sh
kubectl apply -f /Users/dqx0/dqx0-sites/k8s/ingress.yaml
```

Optional: trust the generated certificate in macOS Keychain.
The script outputs `/tmp/dqx0-tls/tls.crt`.

## 6) Verify host routing

```bash
curl -k https://hello.dqx0 | head -n 4
curl -k https://app.dqx0 | head -n 4
curl -k https://api.dqx0
```

## 7) Remove old compose stack (optional)

```bash
cd /Users/dqx0/dqx0-sites
docker compose down
```
