{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        lfs.enable = true;
        signing.format = "openpgp";
        settings = {
          user.name = "admiraladmirable";
          user.email = "rick.morrow1204@gmail.com";
          aliases.undo = "reset HEAD~1 --mixed";
          credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
          color.ui = "auto";
          push = {
            default = "simple";
            autoSetupRemote = "true";
          };
        };
      };

      programs.gh.enable = true;

      programs.tmux = {
        enable = true;
        clock24 = true;
        mouse = false;
        newSession = true;
        historyLimit = 5000;
        terminal = ",xterm*:Tc";
        keyMode = "vi";
        plugins = with pkgs; [
          tmuxPlugins.sensible
          tmuxPlugins.dracula
        ];
        extraConfig = ''
          set -g @plugin 'dracula/tmux'
        '';
      };

      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };

      programs.bash = {
        enable = true;
        sessionVariables = {
          KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
          EDITOR = "nix run github:admiraladmirable/nixCats --refresh";
          KUBE_EDITOR = "nix run github:admiraladmirable/nixCats --refresh";
        };

        shellAliases = {
          k = "kubectl";
          nvim = "nix run github:admiraladmirable/nixCats --refresh";
          kctx = "kubectx";
          kns = "kubens";
        };

        initExtra = ''
          # Kubectl efficient copy aliases

          # Copy TO pod (local -> pod)
          # Usage: kcp-to <namespace> <pod> <local-src-dir> <pod-dst-dir>
          kcp-to() {
            local ns="$1" pod="$2" src="$3" dst="$4"
            if [[ -z "$ns" || -z "$pod" || -z "$src" || -z "$dst" ]]; then
              echo "Usage: kcp-to <namespace> <pod> <local-src-dir> <pod-dst-dir>"
              return 1
            fi
            tar czf - -C "$src" . | kubectl exec -i -n "$ns" "$pod" -- tar xzf - --no-same-owner -C "$dst"
          }

          # Copy FROM pod (pod -> local)
          # Usage: kcp-from <namespace> <pod> <pod-src-dir> <local-dst-dir>
          kcp-from() {
            local ns="$1" pod="$2" src="$3" dst="$4"
            if [[ -z "$ns" || -z "$pod" || -z "$src" || -z "$dst" ]]; then
              echo "Usage: kcp-from <namespace> <pod> <pod-src-dir> <local-dst-dir>"
              return 1
            fi
            mkdir -p "$dst"
            kubectl exec -n "$ns" "$pod" -- tar czf - -C "$src" . | tar xzf - --no-same-owner -C "$dst"
          }

          # Bidirectional wrapper (auto-detects direction based on ':' in path)
          # Usage: kcp <namespace> <pod:remote-path> <local-path>  OR  <local-path> <pod:remote-path>
          kcp() {
            local ns="$1" arg2="$2" arg3="$3"
            if [[ -z "$ns" || -z "$arg2" || -z "$arg3" ]]; then
              echo "Usage: kcp <namespace> <pod:remote-path> <local-path>"
              echo "   or: kcp <namespace> <local-path> <pod:remote-path>"
              return 1
            fi
            
            if [[ "$arg2" == *:* ]]; then
              # Format: pod:path local-path (FROM pod)
              local pod="''${arg2%%:*}" remote="''${arg2#*:}" local="$arg3"
              mkdir -p "$local"
              kubectl exec -n "$ns" "$pod" -- tar czf - -C "$remote" . | tar xzf - --no-same-owner -C "$local"
            elif [[ "$arg3" == *:* ]]; then
              # Format: local-path pod:path (TO pod)
              local local="$arg2" pod="''${arg3%%:*}" remote="''${arg3#*:}"
              tar czf - -C "$local" . | kubectl exec -i -n "$ns" "$pod" -- tar xzf - --no-same-owner -C "$remote"
            else
              echo "Error: No pod:path format found"
              return 1
            fi
          }

          convert_timestamp() {
            date -d "$1" +'%Y-%m-%d %H:%M:%S %Z'
          }
        '';

        bashrcExtra = ''
          source <(kubectl completion bash)
          complete -o default -F __start_kubectl k

          if tty -s; then
            export GPG_TTY=$(tty)
            gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1 || true
          fi

          if [[ -n "''${PROMPT_COMMAND:-}" ]]; then
            case ";''${PROMPT_COMMAND};" in
              *";history -a;"*) ;;
              *) PROMPT_COMMAND="history -a; ''${PROMPT_COMMAND}" ;;
            esac
          else
            PROMPT_COMMAND="history -a"
          fi

          # Only try to start UWSM from a text TTY login, not in terminals inside Hyprland.
          if [[ -z "''${WAYLAND_DISPLAY:-}" && -z "''${DISPLAY:-}" && "''${XDG_VTNR:-}" == "1" ]]; then
            if uwsm check may-start >/dev/null 2>&1; then
              exec uwsm start default
            fi
          fi
        '';
      };
    };
}
