{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.mocha-configuration =
    { config, pkgs, ... }:
    {
      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # AMD settings
      boot.kernelModules = [ "amdgpu" ];
      boot.kernelParams = [
        "amd_pstate=active"
        "amdgpu.dc=1"
      ];

      # Btrfs optimizations
      fileSystems."/".options = [
        "subvol=@"
        "compress=zstd"
        "noatime"
      ];
      fileSystems."/home".options = [
        "subvol=@home"
        "compress=zstd"
        "noatime"
      ];

      # Enable OpenGL
      hardware.graphics = {
        enable = true;
        enable32Bit = true; # Steam
      };

      # Lock screen
      security.pam.services.waylock = { };

      # Set networking options.
      networking.hostName = "mocha";
      networking.networkmanager.enable = true;

      hardware.mediatek-mt7927.enable = true;

      age.secrets.headscale-authkey-mocha = {
        file = ../../secrets/headscale-authkey-mocha.age;
        owner = "root";
        group = "root";
        mode = "0400";
      };

      services.tailscale.authKeyFile = config.age.secrets.headscale-authkey-mocha.path;

      age.secrets.cloudflare-dns.file = ../../secrets/cloudflare-dns.age;

      services.webProxy = {
        domain = meta.tailnetDomain;
        wildcard = true;
        tailnetOnly = true;
        credentialsFile = config.age.secrets.cloudflare-dns.path;
      };

      # Set your time zone.
      time.timeZone = "America/New_York";

      # Enable ly display manager
      services.displayManager.ly.enable = true;

      # Enable sound.
      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };

      # Define user account.
      users.users.anish = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "networkmanager"
          "media"
        ];
      };

      users.defaultUserShell = pkgs.zsh;

      programs.zsh.enable = true;
      programs.nix-ld.enable = true;
      programs.hyprland.enable = true;

      environment.variables = {
        NIXOS_OZONE_WL = 1; # Configure Electron / CEF apps to use Wayland
      };

      # Enable the OpenSSH daemon.
      services.openssh.enable = true;

      # Enable the flatpak service
      services.flatpak.enable = true;

      # USB drive mounting
      services.udisks2.enable = true;

      system.stateVersion = "25.05";
    };
}
