{
  flake.modules.nixos.affogato-hardware-configuration =
    { lib, ... }:
    {
      # Hetzner Cloud virtio-scsi
      boot.initrd.availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
