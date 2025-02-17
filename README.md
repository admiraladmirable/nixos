## Deploy to remote machine on network

```
sudo nixos-rebuild switch --flake .#homelab --target-host rmrf@homelab --verbose --use-remote-sudo
```

## Runbook :)

During a network update, the etcd member can get out of date which doesn't allow restarting the k3s service. Do work around this, we can manually reset it.

```
nix-shell -p etcd

sudo ETCDCTL_ENDPOINTS='https://127.0.0.1:2379' ETCDCTL_CACERT='/var/lib/rancher/k3s/server/tls/etcd/server-ca.crt' ETCDCTL_CERT='/var/lib/rancher/k3s/server/tls/etcd/server-client.crt' ETCDCTL_KEY='/var/lib/rancher/k3s/server/tls/etcd/server-client.key' ETCDCTL_API=3 etcdctl member list

sudo ETCDCTL_ENDPOINTS='https://127.0.0.1:2379' ETCDCTL_CACERT='/var/lib/rancher/k3s/server/tls/etcd/server-ca.crt' ETCDCTL_CERT='/var/lib/rancher/k3s/server/tls/etcd/server-client.crt' ETCDCTL_KEY='/var/lib/rancher/k3s/server/tls/etcd/server-client.key' ETCDCTL_API=3 etcdctl member update <member-id> --peer-urls="https://<new-ip>:2380"

```

