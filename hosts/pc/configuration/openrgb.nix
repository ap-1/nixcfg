{ pkgs, ... }:

{
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
    server.port = 6742;
  };

  # Necessary for some B650/AMD boards to see the SMBus
  boot.kernelParams = [ "acpi_enforce_resources=lax" ];

  environment.systemPackages = [ pkgs.i2c-tools ];
}
