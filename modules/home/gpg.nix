{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentry.package = if pkgs.stdenv.isDarwin
      then pkgs.pinentry_mac
      else pkgs.pinentry-curses;
  };
}
