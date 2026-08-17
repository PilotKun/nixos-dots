{ config, pkgs, inputs,... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = true;  # lets iwd handle DHCP itself, replacing NM's job
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.displayManager.ly.enable = true;
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    displayManager.sessionCommands = ''
      xwallpaper --zoom ~/Pictures/walls/wall1.png
    '';

    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [
        pulsectl-asyncio
      ];
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users."pilot" = {
    isNormalUser = true;
    description = "pilot";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [ tree ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  programs.xfconf.enable = true;

  security.polkit.enable = true;

  programs.adb.enable = true;

  programs.steam.enable = true;

  programs.firefox.enable = true;

  services.picom.enable = true;

  services.power-profiles-daemon.enable = true;

  services.logind.powerKey = "ignore";

  services.qbittorrent.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "pilot" ];

  # Flatpak support (for LocalSend and Heroic, installed as Flatpaks)
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Required by Flatpak - qtile doesn't provide this itself like a full DE would
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Mount HDD or extra storage
  # Mount HDD1
  fileSystems."/mnt/HDD1" = {
    device = "/dev/disk/by-uuid/EBE9-B932";
    fsType = "exfat";
    options = [ "nofail" "uid=1000" "gid=100" "dmask=022" "fmask=133" ];
  };

  # Mount HDD2
  fileSystems."/mnt/HDD2" = {
    device = "/dev/disk/by-uuid/6A6F-B936";
    fsType = "exfat";
    options = [ "nofail" "uid=1000" "gid=100" "dmask=022" "fmask=133" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim
  git
  alacritty
  fastfetch
  fzf
  ripgrep
  rofi
  gemini-cli
  impala
  brightnessctl
  playerctl
  wireplumber
  cava
  pulseaudio
  pavucontrol
  helvum
  qbittorrent
  zbar
  speedcrunch
  xorg.xkill
  hyprpaper
  hyprlock
  hypridle
  waybar
  wl-clipboard
  rofi-wayland
  wofi
  grim
  slurp
  mako
  cliphist
  libnotify
  pkgs.polkit_gnome
  starship
  pkgs.cargo
  pkgs.rustc
  pkgs.pkg-config
  pkgs.openssl
  wlogout
  gnumake
 # ------- #
  brave
  firefox
  xclip
  vscode
  vesktop
  themix-gui
  nwg-look
  libsForQt5.qt5ct
  kdePackages.qt6ct
  libsForQt5.qtstyleplugin-kvantum
  kdePackages.qtstyleplugin-kvantum  
  stremio
  # ------- #
  btop
  flameshot
  bluetui
  xarchiver
  bat
  eza
  yazi
  satty
  # ------- #
  nautilus
  sushi
  ffmpegthumbnailer
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.fira-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.udisks2.enable = true;
  services.devmon.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?

}
