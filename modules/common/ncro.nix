{ inputs, ... }:
{
  flake.modules.nixos.ncro =
    { lib, ... }:
    {
      imports = [ inputs.ncro.nixosModules.ncro ];

      services.ncro = {
        enable = true;
        settings = {
          server.listen = ":5000";

          upstreams = [
            {
              url = "https://cache.nixos.org";
              priority = 10;
              public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
            }
            {
              url = "https://nix-community.cachix.org";
              priority = 20;
              public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
            }
            {
              url = "https://devenv.cachix.org";
              priority = 30;
              public_key = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
            }
            {
              url = "https://cachix.cachix.org";
              priority = 40;
              public_key = "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
            }
            {
              url = "https://attic.xuyh0120.win/lantian";
              priority = 50;
              public_key = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
            }
            {
              url = "https://numtide.cachix.org";
              priority = 70;
              public_key = "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE=";
            }
          ];

          cache = {
            db_path = "/var/lib/ncro/routes.db";
            negative_ttl = "10m";
          };

          logging = {
            level = "info";
            format = "json";
          };
        };
      };

      # Route all substitution on this host through ncro
      nix.settings.substituters = lib.mkForce [ "http://localhost:5000" ];
    };
}
