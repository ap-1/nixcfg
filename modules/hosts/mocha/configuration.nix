{ inputs, ... }:
{
  flake.modules.nixos.mocha-configuration = { pkgs, ... }: {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # AMD settings
    boot.kernelModules = [ "amdgpu" ];
    boot.kernelParams = [
      "amd_pstate=active"
      "amdgpu.dc=1"
    ];

    # CachyOS kernel (LTO, znver4-tuned)
    nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;

    # Btrfs optimizations
    fileSystems."/".options = [
      "subvol=@"
      "compress=zstd"
      "noatime"
    ];
    fileSystems."/home".options = [
      "subvol=@home"
      "compress=zstd"
      "noatime"
    ];

    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true; # Steam
    };

    # Sunshine capture device
    services.sunshine.settings = {
      adapter_name = "/dev/dri/by-path/pci-0000:03:00.0-card";
      output_name = "0";
    };

    system.stateVersion = "25.05";
  };
}
