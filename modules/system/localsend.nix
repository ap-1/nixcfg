{
  pkgs,
  lib,
  isLinux,
  ...
}:

lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [ localsend ];
  }

  (lib.optionalAttrs isLinux {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  })
]
