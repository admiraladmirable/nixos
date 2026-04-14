{ inputs, ... }:
{
  flake.modules.nixos.framework16AmdAi300 = {
    imports = [ inputs.nixos-hardware.nixosModules.framework-16-amd-ai-300-series ];

    hardware.amdgpu.initrd.enable = true;
  };
}
