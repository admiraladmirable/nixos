{ pkgs, inputs, ... }:
{
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    bash = {
      enable = true;
      sessionVariables = {
        PROMPT_COMMAND = "history -a; $PROMPT_COMMAND";
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
        # EDITOR = "nvim";
        KUBE_EDITOR = "nix run github:admiraladmirable/nixCats --refresh";
      };

      shellAliases = {
        k = "kubectl";
        kctx = "kubectx";
        kns = "kubens";
        nvim = "nix run github:admiraladmirable/nixCats --refresh";
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
      '';

      bashrcExtra = ''
        source <(kubectl completion bash)
        complete -o default -F __start_kubectl k
      '';
    };
  };
}
