{
  flake.modules.nixos.macchiato-configuration = { pkgs, ... }: {
    networking.hostName = "macchiato";

    hardware.asahi = {
      enable = true;
      # non-redistributable, loaded from the ESP at boot
      peripheralFirmwareDirectory = null;
    };

    boot.blacklistedKernelModules = [ "appledrm" ];
    boot.extraModprobeConfig = "options appledrm enable_verbose_logging=1";

    # TODO: drop once m1n1 tags a release after v2.0.0
    boot.m1n1Package = pkgs.m1n1.overrideAttrs {
      version = "2.0.0-unstable-2026-11-10";
      src = pkgs.fetchFromGitHub {
        owner = "AsahiLinux";
        repo = "m1n1";
        rev = "cf37927d6bf47c502136e7d2c9e61f946b0b8745";
        hash = "sha256-bgphbGh2xflPGsmM0EETEdIKmmHnjr/AEWH7OwML7J4=";
      };
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;

    # Laptop power and lid handling
    services.upower.enable = true;
    services.logind.settings.Login.HandleLidSwitch = "suspend";

    system.stateVersion = "26.05";
  };
}
