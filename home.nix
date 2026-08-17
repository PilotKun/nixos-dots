{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dots/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    qtile = "qtile";
    nvim = "nvim";
    alacritty = "alacritty";
    rofi = "rofi";
    picom = "picom";
    hypr = "hypr";
    waybar = "waybar";
    mako = "mako";
  };
in

{
  home.username = "pilot";
  home.homeDirectory = "/home/pilot";
  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    userName = "pilot";
    userEmail = "keerthi.modi1910@gmail.com";
  };

# Symlink Home Manager themes to standard directories so Flatpak can read them
  home.file = {
    ".local/share/themes".source = create_symlink "${config.home.profileDirectory}/share/themes";
    ".local/share/icons".source = create_symlink "${config.home.profileDirectory}/share/icons";
  };

  programs.bash = {
    enable = true;
    initExtra = ''
    eval -- "$(/etc/profiles/per-user/pilot/bin/starship init bash --print-full-init)"
    '';
    shellAliases = {
      btw = "echo i use nixos, btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dots#pixos";
      ls = "eza -lha --group-directories-first --icons=auto";
      lsa = " ls -a";
      cd = "z";
      ff = "fzf --preview 'bat --style=numbers --color=always {}'";
      pilothomelab = "ssh pilot_homelab@192.168.0.104";
    };
  };

  programs.tmux.enable = true;

  programs.starship.enable = true;
  home.file.".config/starship.toml".source = create_symlink "${dotfiles}/starship.toml";

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

# GTK Configuration
  gtk = {
    enable = true;
    
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-dark-gtk;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    cursorTheme = {
      name = "capitaine-cursors-gruvbox";
      package = pkgs.capitaine-cursors-themed;
    };

    # Force GTK3 and GTK4 apps to prefer dark mode
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Force libadwaita apps (like modern Nautilus) to use dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };  

  # Clipboard manager - pairs with rofi + xclip, which are already in your setup.
  # Bind a key in your qtile config to run `clipmenu` to pull up the picker.
  services.clipmenu.enable = true;
  services.cliphist.enable = true;

  # Polkit authentication agent (needed since qtile/Hyprland don't provide one)
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Notification daemon
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "10x50";
        frame_width = 2;
        font = "JetBrainsMono Nerd Font 10";
      };
      urgency_normal = {
        timeout = 5;
      };
    };
  };

  programs.mpv = {
    enable = true;
    
    # You can configure MPV settings here as well
    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
    };

    # Inject your chosen scripts directly into the package
    package = pkgs.mpv.override {
      scripts = with pkgs.mpvScripts; [
        mpris
        thumbfast
        smartskip
        mpv-cheatsheet
        mpris
        webtorrent-mpv-hook
      ];
    };
  };

  # Opens magnet links in stremio instead of qbittorrent
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/magnet" = [ "smartcode-stremio.desktop" ];
    };
  };

# Ensure environment variables are set for GTK and Qtile
  home.sessionVariables = {
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
    DOTFILES_DIR = "${config.home.homeDirectory}/nixos-dots";
    WALLPAPERS_DIR = "${config.home.homeDirectory}/Pictures/walls"; # Adjust this path to wherever your backgrounds are stored
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  home.sessionPath = [ "$HOME/.cargo/bin" ];

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    xclip
    xwallpaper
    fd
    xdg-utils
    file-roller
    scrcpy
    ffmpeg
    yt-dlp
    alsa-lib
  ];
}
