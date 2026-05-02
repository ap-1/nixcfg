{
  flake.modules.nixos.games =
    { pkgs, ... }:
    {
      nixpkgs.config.permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];

      nixpkgs.overlays = [
        (final: prev: {
          openldap = prev.openldap.overrideAttrs (_: {
            doCheck = false;
          });
        })
      ];

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = false;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
          mangohud
        ];
      };

      # Native games
      environment.systemPackages = with pkgs; [
        (heroic.override {
          extraPkgs =
            pkgs': with pkgs'; [
              gamescope
              gamemode
            ];
        })
      ];

      # Gamescope
      programs.gamescope = {
        enable = true;
        capSysNice = false;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };

      # Gamemode
      programs.gamemode.enable = true;

      users.users.anish.extraGroups = [ "gamemode" ];
    };

  flake.modules.homeManager.games =
    { pkgs, ... }:
    {
      programs.lutris = {
        enable = true;
        extraPackages = with pkgs; [
          gamescope
          gamemode
        ];
        winePackages = with pkgs; [
          wineWow64Packages.stable
        ];
        protonPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      programs.mangohud = {
        enable = true;
        enableSessionWide = true;
        settings = {
          no_display = true;
          fps_limit = [
            0
            60
            144
            240
          ];
          fps_limit_method = "late";
          vsync = 2;
          gl_vsync = 1;

          toggle_hud = "Shift_R+F12";
          toggle_fps_limit = "Shift_R+F1";

          fps = true;
          show_fps_limit = true;
          frametime = true;
          frame_timing = true;
          present_mode = true;
          core_load = false;
          ram = true;

          cpu_stats = true;
          cpu_temp = true;
          cpu_power = true;
          cpu_text = "CPU";
          cpu_mhz = true;

          throttling_status = true;
          gpu_stats = true;
          gpu_temp = true;
          gpu_core_clock = true;
          gpu_mem_clock = true;
          gpu_power = true;
          gpu_text = "GPU";
          vram = true;
        };
      };
    };
}
