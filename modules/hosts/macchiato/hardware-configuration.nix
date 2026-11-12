{
  flake.modules.nixos.macchiato-hardware-configuration =
    { lib, modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "usb_storage"
        "sdhci_pci"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-partuuid/a87b4888-3b42-4061-92e1-a01b72eeaae8";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
    };
}
