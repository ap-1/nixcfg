{
  flake.modules.homeManager.hyprland = { ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      extraConfig = builtins.readFile ./hyprland.lua;
    };

    services.hyprpolkitagent.enable = true;

    xdg.configFile."hypr/modules".source = ./modules;
    xdg.configFile."wl-kbptr/config".source = ./wl-kbptr.conf;

    # enabled manually for catppuccin
    programs.foot = {
      enable = true;
      settings.main.font = "monospace:size=12";
      settings.colors-dark.alpha = 0.8;
    };
    programs.rofi.enable = true;
    services.dunst.enable = true;
  };

  flake.modules.nixos.hyprland = { pkgs, ... }: {
    programs.hyprland.enable = true;
    environment.variables.NIXOS_OZONE_WL = 1; # Configure Electron / CEF apps to use Wayland

    programs.ydotool.enable = true;
    users.users.anish.extraGroups = [ "ydotool" ];

    # Lock screen
    security.pam.services.waylock = { };

    services.displayManager.ly.enable = true;

    # Keyring
    services.oo7.enable = true;
    services.dbus.packages = [ pkgs.gcr_3 ];

    # USB drive mounting
    services.udisks2.enable = true;

    programs.gpu-screen-recorder.enable = true; # setcap KMS wrapper for promptless capture

    environment.systemPackages = with pkgs; [
      # TODO: https://hydra.nixos.org/build/352556926
      (waylock.overrideAttrs (old: {
        zigBuildFlags = old.zigBuildFlags ++ lib.optional stdenv.hostPlatform.isAarch64 "-Dllvm";
      }))
      playerctl
      brightnessctl
      grim # screenshot
      slurp # region selection
      (writeShellApplication {
        name = "capture";
        runtimeInputs = [
          grim
          slurp
          jq
          wl-clipboard
          libnotify
        ];
        text = builtins.readFile ./capture.sh;
      })
    ];
  };
}
