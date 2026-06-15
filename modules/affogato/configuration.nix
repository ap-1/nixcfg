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
      age.secrets.affogato-password.file = ../../secrets/affogato-password.age;
      age.secrets.headscale-authkey-affogato = {
        file = ../../secrets/headscale-authkey-affogato.age;
        owner = "root";
        group = "root";
        mode = "0400";
      };

      services.tailscale.authKeyFile = config.age.secrets.headscale-authkey-affogato.path;

      boot.loader.grub = {
        enable = true;
        efiSupport = false;
      };

      # zram swap
      zramSwap.enable = true;

      networking.hostName = "affogato";
      networking.useDHCP = true;

      time.timeZone = "UTC";

      services.openssh = {
        enable = true;
        openFirewall = false;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "prohibit-password";
        };
      };

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

      users.mutableUsers = false;
      users.users.root.hashedPasswordFile = config.age.secrets.affogato-password.path;
      users.users.anish.hashedPasswordFile = config.age.secrets.affogato-password.path;

      security.sudo.wheelNeedsPassword = false;

      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;

      system.stateVersion = "26.11";
    };
}
