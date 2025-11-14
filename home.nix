{ pkgs, lib, xdg-termfilepickers, neovim-nightly-overlay, ...}:

{
  nixpkgs.config.allowUnfreePredicate = pkg : builtins.elem (lib.getName pkg) [
    "discord-canary"
  ];

  home.packages = with pkgs; [
    networkmanagerapplet
    discord-canary
    libnotify
  ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions.force = true;
      settings = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/dotfiles#ap-1";
      config = "nvim ~/dotfiles/configuration.nix";
      flake = "nvim ~/dotfiles/flake.nix";
      home = "nvim ~/dotfiles/home.nix";	  
      
      ls = "eza -la";
      cat = "bat --style=plain --paging=never";
    };

    oh-my-zsh = {
      enable = true;
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    plugins = {
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "a63550b2f91f0553cc545fd8081a03810bc41bc0";
        sha256 = "sha256-PYeR6fiWDbUMpJbTFSkM57FzmCbsB4W4IXXe25wLncg=";  
      };
    };

    initLua = ''
      require("starship"):setup()
    '';
  };
  
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Anish Pallati";
        email = "i@anish.land";
      };
      init = {
        defaultBranch = "main";
      };
    };
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      format = "ssh";
      signByDefault = true;
    };
  };

  programs.neovim = {
    enable = true;
    package = neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";

    eza.enable = true;
    yazi.enable = true;
    nvim.enable = true;
    atuin.enable = true;
    starship.enable = true;
    hyprland.enable = true;
    bat.enable = true;
    foot.enable = true;
    rofi.enable = true;
    dunst.enable = true;
    waybar.enable = true;
  };

  programs.bat.enable = true;
  programs.foot.enable = true;
  programs.rofi.enable = true;
  services.dunst.enable = true;
  programs.waybar.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };
    };
  };

  services.xdg-desktop-portal-termfilepickers = {
    enable = true;
    package = xdg-termfilepickers.packages.${pkgs.stdenv.hostPlatform.system}.default;
    config = {
      # --app-id used by a hyprland windowrule
      terminal_command = [(lib.getExe pkgs.foot)];
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    config = {
      common = {
        default = [ "hyprland" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilepickers" ];
      };
    };
  };

  home.sessionVariables = {
    GTK_USE_PORTAL = "1"; # legacy
    GDK_DEBUG = "portals"; # termfilechooser
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
  };

  home.stateVersion = "25.05";
}

