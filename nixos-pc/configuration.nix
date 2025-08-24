# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, lib, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./plasma6.nix
    ./hyprland.nix
    inputs.home-manager.nixosModules.default
  ];  
  
  # Nvidia
  hardware.graphics.enable = true;
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.xone.enable = true;
  hardware.usb-modeswitch.enable = true; #WLAN Stick

  boot = {
    kernelParams = [ "nvidia-drm.fbdev=1" "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];
    loader = {
      timeout = 0;
      grub.timeoutStyle = "hidden";
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Silent Boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
  };

  networking.hostName = "nixos-pc"; # Define your hostname.

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
  #Sudo without password
  security.sudo.extraRules = [
    { users = ["noel"];
      commands = [
        { command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
  home-manager.users.noel = { config, pkgs, ... }: {
    home.file = {
      ".config/alacritty" = {
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-pc/config/alacritty";
      };
      ".p10k.zsh" = {
          source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-pc/config/p10k/p10k.zsh";
      };
    };
    home.shellAliases = {
      "rebuild-nix"="bash /etc/nixos/scripts/nixos-rebuild.sh";
      "push-nix"="bash /etc/nixos/scripts/nixos-push.sh";
    };
    programs.zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
        #highlight = "fg=#ff00ff,bg=cyan,bold,underline";
      };
      initContent = "source ~/.p10k.zsh";
    };
    programs.git = {
      enable = true;
      userName = "NoelTheGnom";
      userEmail = "noeljarling@gmail.com";
      extraConfig = {
          init.defaultBranch = "main";
          safe.directory = "/etc/nixos";
      };
    };
    programs.ssh = {
      enable = true;
      matchBlocks = {
        server = {
          hostname = "10.213.186.204";
          user = "noel";
          identityFile = "~/.ssh/nixos-server";
        };
      };
    };
    home.stateVersion = "24.05";
  };

  #Samba network shares
  fileSystems."/mnt/share/docker" = {
    device = "//10.213.186.204/docker";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/etc/nixos/nixos-pc/secrets/smb-secrets,uid=1000,gid=100"];
  };
  fileSystems."/mnt/share/nas" = {
    device = "//10.213.186.204/nas";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/etc/nixos/nixos-pc/secrets/smb-secrets,uid=1000,gid=100"];
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
    bind
    psmisc
    #prusa-slicer
    jellyfin-media-player
    xow_dongle-firmware # Xbox one dongle firmware 
    google-chrome
    gimp
    
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
