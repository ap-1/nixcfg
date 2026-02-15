{
  flake.modules.homeManager.gpg =
    { pkgs, ... }:
    {
      programs.gpg.enable = true;

      services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        defaultCacheTtl = 86400;
        maxCacheTtl = 86400;
        pinentry.package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
      };
    };
}
