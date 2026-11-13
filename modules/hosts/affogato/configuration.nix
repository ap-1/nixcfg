{ config, ... }:
let
  meta = config.flake.meta;
  hosts = config.flake.hosts;
in
{
  flake.modules.nixos.affogato-configuration = {
    age.identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

    networking.hostName = "affogato";

    services.cloud-init.enable = false;

    # cloud-init is off, so configure the hetzner interface for systemd-networkd
    systemd.network.networks."30-wan" = {
      matchConfig.Name = "enp1s0"; # hetzner cloud virtio NIC
      networkConfig.DHCP = "ipv4";
      address = [ "${hosts.affogato.publicIpv6}/64" ];
      routes = [ { Gateway = "fe80::1"; } ]; # hetzner link-local gateway
    };

    services.openssh = {
      openFirewall = false;
      settings.PasswordAuthentication = false;
    };

    networking.firewall = {
      interfaces.tailscale0.allowedTCPPorts = [ 22 ];
      allowedTCPPorts = [ 22 ];
    };

    users.users.root.openssh.authorizedKeys.keys = [
      meta.sshKey
    ];

    system.stateVersion = "26.11";
  };
}
