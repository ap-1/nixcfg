{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.affogato-configuration =
    {
      config,
      pkgs,
      ...
    }:
    {
      age.identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
      age.secrets.headscale-authkey-affogato = {
        file = ../../secrets/headscale-authkey-affogato.age;
        owner = "root";
        group = "root";
        mode = "0400";
      };

      services.tailscale.authKeyFile = config.age.secrets.headscale-authkey-affogato.path;

      networking.hostName = "affogato";

      services.cloud-init.enable = false;

      services.openssh.openFirewall = false;

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

      users.users.root.openssh.authorizedKeys.keys = [
        meta.sshKey
      ];

      users.users.anish = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          meta.sshKey
        ];
      };

      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;

      system.stateVersion = "26.11";
    };
}
