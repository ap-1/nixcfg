{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.immich =
    { config, ... }:
    {
      age.secrets.kanidm-oauth2-immich = {
        file = ../../secrets/kanidm-oauth2-immich.age;
        owner = "immich";
        group = "immich";
      };

      services.webProxy.sites.immich = "reverse_proxy http://127.0.0.1:12283";

      services.immich = {
        enable = true;
        host = "127.0.0.1";
        port = 12283;
        mediaLocation = "/media/immich";
        machine-learning.enable = true;

        # Hardware Accelerated Video Transcoding
        accelerationDevices = null;

        settings.oauth = {
          enabled = true;
          issuerUrl = "${meta.idpUrl}/oauth2/openid/immich/.well-known/openid-configuration";
          clientId = "immich";
          clientSecret._secret = config.age.secrets.kanidm-oauth2-immich.path;
          scope = "openid email profile";
          buttonText = "Login with Kanidm";
          autoRegister = true;
        };
      };

      users.users.immich.extraGroups = [
        "video"
        "render"
      ];

      # Directories
      systemd.tmpfiles.rules = [
        "d /media/immich 0750 immich immich -"
      ];
    };
}
