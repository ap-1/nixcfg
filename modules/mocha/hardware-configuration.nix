{
  flake.modules.nixos.mocha-hardware-configuration =
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
        "usbhid"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      boot.initrd.supportedFilesystems = [ "btrfs" ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/35ec55c3-6916-450d-91af-c054f15144d7";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-uuid/35ec55c3-6916-450d-91af-c054f15144d7";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/FD6B-325F";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/4db2cb68-8a0b-4a18-805c-516a799efd6f"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
