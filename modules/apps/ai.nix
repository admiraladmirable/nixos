{ inputs, config, ... }:
{
  flake.modules.homeManager.base =
    { osConfig, pkgs, ... }:
    let
      cudaPkgs = import inputs.nixpkgs {
        system = pkgs.stdenv.hostPlatform.system;
        overlays = [ config.flake.overlays.default ];
        config = {
          allowUnfree = true;
          cudaSupport = osConfig.rmrf.cuda.enable;
          permittedInsecurePackages = [
            "python3.13-vllm-0.16.0"
          ];
        };
      };
    in
    {
      home.packages = with pkgs; [
        claude-code
        inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
        (llama-cpp.override { cudaSupport = osConfig.rmrf.cuda.enable; })
        # vllm 0.16.0 in current nixpkgs pin has 3 known CVEs. Use Python 3.13
        # because tensorflow-bin does not support Python 3.14 on x86_64-linux.
        # (cudaPkgs.python313Packages.toPythonApplication (
        #   cudaPkgs.python313Packages.vllm.override { gpuTargets = [ "12.0" ]; }
        # ))
        opencode
        opencode-desktop
        pi-coding-agent
      ];
    };
}
