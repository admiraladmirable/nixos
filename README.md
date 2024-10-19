## Deploy to remote machine on network

```
sudo nixos-rebuild switch --flake .#homelab --target-host rmrf@homelab --verbose --use-remote-sudo
```

