{ inputs, ... }: {
  flake.modules.nixos.cliproxyapi =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        "${inputs.nixpkgs-cliproxyapi}/nixos/modules/services/misc/cliproxyapi.nix"
      ];

      age.secrets.cliproxyapi-api-key.file = ../../secrets/cliproxyapi-api-key.age;
      age.secrets.cliproxyapi-management.file = ../../secrets/cliproxyapi-management.age;

      services.cliproxyapi = {
        enable = true;
        package = inputs.nixpkgs-cliproxyapi.legacyPackages.${pkgs.stdenv.hostPlatform.system}.cliproxyapi;
        settings = {
          host = "127.0.0.1";
          port = 8317;
          api-keys = [ { _secret = config.age.secrets.cliproxyapi-api-key.path; } ];
          remote-management = {
            allow-remote = false;
            disable-control-panel = true;
            secret-key._secret = config.age.secrets.cliproxyapi-management.path;
          };
        };
      };
    };
}
