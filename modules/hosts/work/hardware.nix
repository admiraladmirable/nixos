{ ... }:
{
  flake.modules.nixos.work =
    {
      config,
      lib,
      pkgs,
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
        "thunderbolt"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/mapper/luks-e22706e6-aea5-40ce-8143-abf832a9f0ca";
        fsType = "ext4";
      };

      boot.initrd.luks.devices."luks-e22706e6-aea5-40ce-8143-abf832a9f0ca".device =
        "/dev/disk/by-uuid/e22706e6-aea5-40ce-8143-abf832a9f0ca";

      boot.initrd.luks.devices."luks-7765811b-6203-48a0-bb2d-8d92913def76".device =
        "/dev/disk/by-uuid/7765811b-6203-48a0-bb2d-8d92913def76";

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/9273-C170";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/mapper/luks-7765811b-6203-48a0-bb2d-8d92913def76"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
