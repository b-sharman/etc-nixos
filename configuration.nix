# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # Try to fix cold reboots
  # https://www.reddit.com/r/archlinux/comments/vz5apu/a_solution_to_mce_hardware_error_reboots_on_amd/
  boot.kernelParams = [
    "processor.max_cstate=5"
  ];

  networking.hostName = "shadowfax"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  virtualisation.docker.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "3l";
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = [ pkgs.xterm ];
  };

  # TODO: doesn't quite work in console
  # cur activates the symbols layer rather than the cursor layer
  console.useXkbConfig = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.byron = {
    isNormalUser = true;
    description = "Byron";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    packages = with pkgs; [
      darktable
      delve
      discord
      droidcam
      gnome-sound-recorder
      go
      gopls
      harper
      neovim
      obs-studio
      ripgrep
      ruff
      svelte-language-server
      uv
      yt-dlp
      zsh
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    dconf-editor
    fd
    file
    firefox
    fzf
    gimp
    git
    google-chrome

    # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
    gst_all_1.gstreamer
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    # I mean, it says ugly, and I don't think I really need it; do I really want to install something ugly on my computer?
    # gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst_all_1.gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    gst_all_1.gst-vaapi

    minikube
    nodejs_22
    papers
    ptyxis
    python3
    (texlive.combine {
      inherit (texlive) scheme-medium datetime2 datetime2-english enumitem titlesec;
    })
    unzip
    vim
    wl-clipboard
    zip
  ];

  environment.gnome.excludePackages = (with pkgs; [
    cheese
    epiphany
    geary
    gnome-calendar
    gnome-characters
    gnome-connections
    gnome-contacts
    gnome-disk-utility
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-tour
    gnome-weather
    seahorse
    simple-scan
    snapshot
    totem
    yelp
  ]);

  # get zsh completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  programs.obs-studio.plugins = [ "droidcam-obs" ];
  programs.steam.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    audio.enable = true;
    jack.enable = true;
    pulse.enable = true;

    extraConfig.pipewire.microphone = {
      "context.objects" = [
        {
          factory = "adapter";
          args = {
            "factory.name" = "api.alsa.pcm.source";
            "node.name" = "microphone";
            "node.description" = "microphone whee woohoo";
            "media.class" = "Audio/Source";
            "api.alsa.path" = "hw:2,0";
          };
        }
      ];
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
