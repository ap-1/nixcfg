{ inputs, ... }: {
  flake.modules.nixos.sunshine = { pkgs, ... }: {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true; # Wayland/Hyprland screen capture
      openFirewall = true;
      settings.key_rightalt_to_key_win = "enabled";
      package = inputs.nixpkgs-sunshine.legacyPackages.${pkgs.stdenv.hostPlatform.system}.sunshine;
    };

    # right-alt to meta remap leaks ALT alongside meta (upstream bug)
    # https://github.com/LizardByte/Sunshine/issues/4531
    nixpkgs.overlays = [
      (_: prev: {
        sunshine = prev.sunshine.overrideAttrs (o: {
          patches = (o.patches or [ ]) ++ [ ./sunshine-rightalt-4531.patch ];
        });
      })
    ];

    services.webProxy.sites.sunshine = ''
      reverse_proxy https://127.0.0.1:47990 {
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';

    # Discovery
    services.avahi = {
      enable = true;
      nssmdns4 = true; # allows system to resolve .local addresses
      publish = {
        enable = true;
        userServices = true; # broadcasts sunshine
        addresses = true; # broadcasts this machine's IP
      };
    };

    # Input configuration
    hardware.uinput.enable = true;
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="input", SYMLINK+="uinput"
    '';

    users.users.anish.extraGroups = [
      "input"
      "video"
      "render"
      "uinput"
    ];
  };

  flake.modules.darwin.sunshine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.sunshine ];
  };

  flake.modules.homeManager.sunshine = { pkgs, ... }: {
    home.packages = [ pkgs.moonlight-qt ];
  };
}
