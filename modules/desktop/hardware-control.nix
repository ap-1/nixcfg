{
  flake.modules.nixos.hardware-control = { pkgs, ... }: {
    # Fan curves (CoolerControl)
    programs.coolercontrol.enable = true;
    services.webProxy.sites.fans = "reverse_proxy http://127.0.0.1:11987";

    # RGB (OpenRGB)
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
      server.port = 6742;
    };

    # Necessary for some B650/AMD boards to see the SMBus
    boot.kernelParams = [ "acpi_enforce_resources=lax" ];

    environment.systemPackages = [ pkgs.i2c-tools ];
  };
}
