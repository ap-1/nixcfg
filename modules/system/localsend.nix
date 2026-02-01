{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ localsend ];

  programs = lib.optionalAttrs pkgs.stdenv.isLinux {
    localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
