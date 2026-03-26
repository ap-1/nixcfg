{
  flake.modules.nixos.games =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
          mangohud
        ];
      };

      # Native games
      environment.systemPackages = with pkgs; [
        tetrio-desktop
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
        capSysNice = true;
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
    { ... }:
    {
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
