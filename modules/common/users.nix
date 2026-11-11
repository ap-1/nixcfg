{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.users = { pkgs, ... }: {
    users.users.anish = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [ meta.sshKey ];
    };

    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;
  };
}
