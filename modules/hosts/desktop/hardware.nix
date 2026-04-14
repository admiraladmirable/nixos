{ ... }:
{
  flake.modules.nixos.desktopMachine =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/4f58a1e2-8d8a-4ba8-b51a-0c76b29a6819";
        fsType = "ext4";
      };

      boot.initrd.luks.devices."luks-934941a0-902d-4b99-b95f-c90ad813a20f".device =
        "/dev/disk/by-uuid/934941a0-902d-4b99-b95f-c90ad813a20f";

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/B6A5-050E";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [ ];

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
