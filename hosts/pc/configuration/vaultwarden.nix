{ config, ... }:

{
  age.secrets.vaultwarden.file = ../../../secrets/vaultwarden.age;

  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden.path;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
      DOMAIN = "http://pc:8222";
      SIGNUPS_ALLOWED = true;
    };
  };
}
