{ ... }:

{
  services.flatpak = {
    enable = true;
    packages = [ "org.vinegarhq.Sober" ];
    overrides = {
      "org.vinegarhq.Sober" = {
        Context = {
          filesystems = [
            "xdg-run/app/com.discordapp.Discord:create"
            "xdg-run/discord-ipc-0"
          ];
          devices = [ "input" ];
        };
      };
    };
  };

  home.sessionVariables = {
    # get flatpaks to show up in rofi
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share";
  };
}
