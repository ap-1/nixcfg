{ ... }:

{
  services.flatpak = {
    enable = true;
    update.onActivation = true;

    packages = [
      "org.vinegarhq.Sober"
      "org.freedesktop.Platform.VulkanLayer.MangoHud"
    ];

    overrides = {
      "org.vinegarhq.Sober" = {
        Context = {
          filesystems = [
            "xdg-run/app/com.discordapp.Discord:create"
            "xdg-run/discord-ipc-0"
            "xdg-config/MangoHud:ro"
          ];
          talk-name = [ "com.feralinteractive.GameMode" ]; # talk to GameMode daemon
          devices = [ "input" ];
        };
        Environment = {
          MANGOHUD = "1";
          MANGOHUD_CONFIGFILE = "/home/anish/.config/MangoHud/MangoHud.conf";
        };
      };
    };
  };

  home.sessionVariables = {
    # get flatpaks to show up in rofi
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share";
  };
}
