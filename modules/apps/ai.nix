{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        claude-code
        inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
        (llama-cpp.override { cudaSupport = true; })
        # vllm 0.16.0 in current nixpkgs pin: 3 known CVEs + broken on python 3.14
        # (tensorflow-bin dep); flashinfer also needs nixpkgs-wide cudaSupport.
        # (python3Packages.toPythonApplication (python3Packages.vllm.override { cudaSupport = true; }))
        opencode
        opencode-desktop
        pi-coding-agent
      ];
    };
}
