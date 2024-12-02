# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./plasma6.nix
      ./hyprland.nix
      inputs.home-manager.nixosModules.default
    ];  

  # Nvidia
  # Enable OpenGL
  hardware.graphics.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  #Silent boot/splashscreen
  boot = {
    /*plymouth = {
      enable = true;
      theme = "lone";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "lone" ];
        })
      ];
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;*/
    kernelParams = [ "nvidia-drm.fbdev=1" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services = {
    xserver = {
      enable = true;
      xkb.layout = "de";
      xkb.variant = "";
      videoDrivers = ["nvidia"]; # Load nvidia driver for Xorg and Wayland
    };
    getty.autologinUser = "noel";
    displayManager.autoLogin.user = "noel";
  };
 

  # Configure console keymap
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.noel = {
    isNormalUser = true;
    description = "Noel";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  home-manager.users.noel = { pkgs, ... }: {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 10;
            y = 10;
          };
          opacity = 0.5;
          blur = true;
        };
      };
    };
    programs.zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
        #highlight = "fg=#ff00ff,bg=cyan,bold,underline";
      };
    };
    home.file.p10k_config = {
      source = ./p10k/p10k.zsh;
      target = "./.p10k.zsh";
    };
    programs.git = {
      enable = true;
      userName = "NoelTheGnom";
      userEmail = "noeljarling@gmail.com";
      extraConfig = {
          init.defaultBranch = "main";
          safe.directory = "/etc/nixos";
      };
      ignores = [
          "/etc/nixos/secrets"
      ];
    };
    programs.ssh.extraConfig = ''
    Host server
    HostName 10.213.186.204
    User noel
    IdentityFile ~/.ssh/serverSSHKey
    '';
    home.stateVersion = "24.05";
  };

  #Samba network shares
  fileSystems."/mnt/share/docker" = {
    device = "//10.213.186.204/docker";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/etc/nixos/secrets/smb-secrets,uid=1000,gid=100"];
  };
  fileSystems."/mnt/share/nas" = {
    device = "//10.213.186.204/nas";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/etc/nixos/secrets/smb-secrets,uid=1000,gid=100"];
  };
  fileSystems."/mnt/share/nixos" = {
    device = "//10.213.186.204/nixos";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/etc/nixos/secrets/smb-secrets,uid=1000,gid=100,rw"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vscode # VS Code
    teamspeak_client # Teamspeak
    cifs-utils #Samba network shares
    easyeffects # Audio Input Processing
    alacritty # Terminal
    nautilus # File Manager
    meslo-lgs-nf # powerlevel10k font
    zsh-powerlevel10k # zsh theme
    winetricks
    wineWowPackages.stable
  ];
  environment.sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  fonts.packages = with pkgs; [
    font-awesome
    fira-sans
  ];
  services.blueman.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.zsh.enable = true;
  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  users.defaultUserShell = pkgs.zsh;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };

  
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
  system.stateVersion = "24.05"; # Did you read the comment?

}
