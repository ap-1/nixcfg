{
  flake.modules.nixos.macchiato-networking = { config, ... }: {
    networking.hostName = "macchiato";

    # TODO: headscale pre-auth key after first boot; then all hosts can share this via common/tailscale.nix
    # age.secrets.headscale-authkey-macchiato = {
    #   file = ../../../secrets/headscale-authkey-macchiato.age;
    #   owner = "root";
    #   group = "root";
    #   mode = "0400";
    # };
    # services.tailscale.authKeyFile = config.age.secrets.headscale-authkey-macchiato.path;
  };
}
