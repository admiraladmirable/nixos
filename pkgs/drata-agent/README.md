# Drata Agent

The work host installs Drata Agent 3.9.0 and starts it as a graphical-session user service. The proprietary amd64 installer is referenced by hash and is not committed.

Import the matching installer once:

```sh
nix-store --add-fixed sha256 /home/rmrf/Downloads/Drata-Agent-linux.deb
```

After adding the new Nix files to Git, apply the configuration:

```sh
sudo nixos-rebuild switch --flake .#work
systemctl --user start drata-agent.service
systemctl --user status drata-agent.service
```

Return to My Drata, select Register Drata Agent, and follow the verification email. The `auth-drata-agent:` URL handler opens the packaged agent. Do not run the agent as root.

For diagnostics:

```sh
journalctl --user -u drata-agent.service -b
```

Drata documents Ubuntu 22.04/24.04 support, not NixOS. Packaging and executable checks do not establish that all compliance checks work on NixOS; verify reported results with your administrator. The package runs directly on the host so the bundled osquery sees the real system.

Updates must be packaged through Nix: import the new installer and update the version and hash in default.nix. The vendor's Debian installer/updater cannot modify the immutable Nix store.

Vendor instructions: https://help.drata.com/en/articles/13612377-install-the-drata-agent

The package also disables the tray window's automatic hide-on-blur handler. This keeps it usable when Hyprland changes focus while the pointer moves from the tray to the window. Click the tray icon again to hide it. The build fails if the expected vendor handler changes, so this patch must be reviewed on upgrades; compliance queries are unchanged.
