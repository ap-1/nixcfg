{ pkgs, ... }:

{
  home.packages = with pkgs; [ syncthing ];

  services.syncthing = {
    enable = true;
    extraOptions = [
      "--gui-address=127.0.0.1:8384"
    ];
    settings = {
      gui = {
        insecureSkipHostcheck = true;
      };
    };
  };

  # could be added to a more general tailscale-serve module
  launchd.agents.tailscale-serve-syncthing = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.tailscale}/bin/tailscale"
        "serve"
        "--bg"
        "--https=8384"
        "http://localhost:8384"
      ];
      RunAtLoad = true;
      LaunchOnlyOnce = true;
    };
  };
}
