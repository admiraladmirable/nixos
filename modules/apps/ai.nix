{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        claude-code
        inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
        lmstudio
        (llama-cpp.override { cudaSupport = true; })
        opencode
        opencode-desktop
      ];
    };
}
