{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./persist.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # zram swap
  zramSwap.enable = true;

  networking.hostName = "affogato";
  networking.useDHCP = true;

  time.timeZone = "UTC";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwjDM2gTgro+aN81I65BFexfLXq1u/8AJ3PmCTX5X/a i@anish.land"
  ];

  users.users.anish = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwjDM2gTgro+aN81I65BFexfLXq1u/8AJ3PmCTX5X/a i@anish.land"
    ];
  };

  users.mutableUsers = false;

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "26.05";
}
