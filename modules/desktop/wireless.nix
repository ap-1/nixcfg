{
  flake.modules.nixos.wireless = {
    networking = {
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      wireless.iwd.enable = true;
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    users.users.anish.extraGroups = [ "networkmanager" ];
  };
}
