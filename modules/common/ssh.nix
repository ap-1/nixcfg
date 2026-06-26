{
  flake.modules.homeManager.ssh =
    {
      pkgs,
      lib,
      ...
    }:
    {
      services.ssh-agent.enable = true;

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings."*" = {
          ServerAliveInterval = 60;
          ServerAliveCountMax = 3;
          IdentityFile = "~/.ssh/id_ed25519";
          AddKeysToAgent = "yes";
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          IgnoreUnknown = "UseKeychain";
          UseKeychain = "yes";
        };
      };
    };
}
