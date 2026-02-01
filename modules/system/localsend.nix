{
  pkgs,
  lib,
  isLinux,
  ...
}:

{
  environment.systemPackages = with pkgs; [ localsend ];
}
// lib.optionalAttrs isLinux {
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
