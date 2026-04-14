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
        };

        bashrcExtra = ''
          source <(kubectl completion bash)
          complete -o default -F __start_kubectl k

          if tty -s; then
            export GPG_TTY=$(tty)
            gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1 || true
          fi

          # Keep history written incrementally without breaking other PROMPT_COMMAND hooks.
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
