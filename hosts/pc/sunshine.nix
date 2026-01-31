{ ... }:

{
  # Sunshine service
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # Wayland/Hyprland screen capture
    openFirewall = true;
  };

  # Discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true; # allows system to resolve .local addresses
    publish = {
      enable = true;
      userServices = true; # broadcasts sunshine
      addresses = true;    # broadcasts this machine's IP
    };
  };

  # Input configuration
  hardware.uinput.enable = true;
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", SYMLINK+="uinput"
  '';

  users.users.anish.extraGroups = [ "input" "video" "render" "uinput" ];
}
