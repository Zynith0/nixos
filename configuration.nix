# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, ... }:

let
  # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # (import "${home-manager}/nixos")
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home-manager.users.zynith = import ./home.nix;
  home-manager.backupFileExtension = "backup";

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
	  wayland
	  wayland-protocols
	  expat
	  fontconfig
	  freetype
	  freetype.dev
	  libGL
	  pkg-config
	  xorg.libX11
	  xorg.libXcursor
	  xorg.libXi
	  xorg.libXrandr
	  libxkbcommon
  ];

  # services.n8n.enable = true;

  virtualisation.docker = {
	  enable = true;

	  daemon.settings = {
		  dns = [ "1.1.1.1" "8.8.8.8" ];
	  };
  };

  virtualisation.oci-containers = {
	  backend = "podman";
	  containers.homeassistant = {
		  volumes = [ "home-assistant:/config" ];
		  environment.TZ = "Europe/Berlin";
		  image = "ghcr.io/home-assistant/home-assistant:stable";
		  extraOptions = [ 
			  "--network=host"
# Pass devices into the container, so Home Assistant can discover and make use of them
			  # "--device=/dev/ttyACM0:/dev/ttyACM0"
		  ];
	  };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.hosts = {
  	"127.0.1.1" = [ "nixos" ];
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  hardware.graphics = {
  	enable = true;
	enable32Bit = true;
	extraPackages = with pkgs; [
		mesa
	];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings.General.Experimental = true;

  services.udev.packages = [
	pkgs.qmk-udev-rules
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  services.displayManager.ly.enable = true;

  # services.displayManager.sddm.theme = "Astronaut";
  services.desktopManager.plasma6.enable = true;

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.wivrn = {
	  enable = true;
	  openFirewall = true;

# Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
# will automatically read this and work with WiVRn (Note: This does not currently
# apply for games run in Valve's Proton)
	  defaultRuntime = true;

# Run WiVRn as a systemd service on startup
	  autoStart = true;

# If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
	  # package = (pkgs.wivrn.override { cudaSupport = true; });

# You should use the default configuration (which is no configuration), as that works the best out of the box.
# However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
  };


  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zynith = {
    isNormalUser = true;
    description = "Zynith";
    extraGroups = [ "networkmanager" "wheel" "input" "wireshark" "docker" "dialout" "uucp" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  services.jellyfin = {
  	enable = true;
	openFirewall = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.wireshark.enable = true;
  
  environment.variables = {
		RUSTICL_ENABLE = "radeonsi";
  };

  # Enable hyprland.
  programs.hyprland.enable = true;

  # Enable niri.
  programs.niri.enable = true;

  # Enable steam.
  programs.steam.enable = true;

  # Enable fish.
  programs.fish.enable = true;
  programs.zsh.enable = true;

  programs.alvr.enable = true;

  # programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = 
  	(with pkgs; [
	  neovim
	  vim
	  hyprland
	  hyprshot
	  discord
	  matugen
	  kitty
	  git
	  ghostty
	  swww
	  quickshell
	  nerd-fonts.jetbrains-mono
	  nerd-fonts._3270
	  nerd-fonts.roboto-mono
	  reaper
	  pavucontrol
	  fish
	  obs-studio
	  krita
	  cargo
	  rust-analyzer
	  rustc
	  mpv
	  fd
	  prismlauncher
	  jre21_minimal
	  go
	  gopls
	  gcc
	  python313Packages.python
	  python313Packages.evdev
	  python313Packages.pygame
	  python313Packages.pygame-gui
	  pyright
	  alvr
	  bluez
	  kdePackages.kdenlive
	  yt-dlp
	  tmux
	  jack2
	  btop
	  feishin
	  jellyfin
	  jellyfin-web
	  jellyfin-ffmpeg
	  picard
	  apple-cursor
	  nwg-look
	  brave
	  nemo
	  sddm-astronaut
	  zsh
	  oh-my-zsh
	  bibata-cursors
	  clang
	  tree-sitter
	  everforest-gtk-theme
	  fzf
	  harper
	  mosquitto
	  slimevr
	  blueberry
	  nodejs_24
	  astro-language-server
	  tailwindcss-language-server
	  gleam
	  hyprpicker
	  wl-clipboard
	  unrar
	  vkbasalt
	  goverlay
	  mangohud
	  android-tools
	  openssl_3
	  openvr
	  nmap
	  wireshark
	  lutris
	  heroic
	  wine
	  vulkan-tools
	  protonup-qt
	  godot
	  playerctl
	  qt6.qtmultimedia
	  qt6.qtwayland
	  kdePackages.qt5compat
	  qmk
	  dos2unix
	  mpvpaper
	  obsidian
	  pulseaudio
	  element-desktop
	  portaudio
	  freecad
	  cmake
  	  orca-slicer
	  plasticity
	  pkg-config
	  sqlite
	  zed-editor
	  vicinae
	  opencode
	  ollama-vulkan
	  unzip
	  jq
	  bun
	  ly
	  nil
	  fastfetch
	  gh
	  zls
	  zig
	  sdrpp
	  chirp
	  catppuccin-kde
	  foot
  ])

  ++

  (with pkgs-unstable; [
	  noctalia-shell
	  dms-shell
  ]);

  fonts.packages = with pkgs; [
	  monocraft
	  nerd-fonts._3270
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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 2089 8080 1883 8123 9943 9944 4040 9942 8082 9001 9000 ];
  networking.firewall.allowedUDPPorts = [ 2089 8080 1883 8123 9943 9944 4040 9942 8082 9001 9000 9999 20002 ];
  networking.firewall.allowedTCPPortRanges = [ 
	  { from = 8000; to = 8010; } 
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
