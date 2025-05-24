# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.graceful = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #systemd.watchdog.device = "/dev/watchdog";
  #systemd.watchdog.runtimeTime = "60s";
  #systemd.watchdog.rebootTime = "1min";
  #services.watchdogd.enable = true;

  networking.hostName = "nixos-server"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.noel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILx/IDxuEV2sgSEiPq1Lx4yq2AksiWhuU7LOZaGyhCfC noel@nixos"];
  };

  #Define user accounts for docker containers

  #One media group for access to the media folder
  users.groups.media.gid = 811;

  users.groups.homeassistant.gid = 801;
  users.users.homeassistant.uid = 801;
  users.users.homeassistant.group = "homeassistant";

  users.groups.pihole.gid = 802;
  users.users.pihole.uid = 802;
  users.users.pihole.group = "pihole";

  users.groups.samba.gid = 803;
  users.users.samba.uid = 803;
  users.users.samba.group = "samba";
  

  users.groups.homepage.gid = 804;
  users.users.homepage.uid = 804;
  users.users.homepage.group = "homepage";

  users.groups.factorio.gid = 805;
  users.users.factorio.uid = 805;
  users.users.factorio.group = "factorio";

  users.groups.jellyfin.gid = 806;
  users.users.jellyfin.uid = 806;
  users.users.jellyfin.group = "jellyfin";
  users.users.jellyfin.extraGroups = ["media"];

  users.groups.prowlarr.gid = 807;
  users.users.prowlarr.uid = 807;
  users.users.prowlarr.group = "prowlarr";

  users.groups.qbittorrent.gid = 808;
  users.users.qbittorrent.uid = 808;
  users.users.qbittorrent.group = "qbittorrent";
  users.users.qbittorrent.extraGroups = ["media"];

  users.groups.radarr.gid = 809;
  users.users.radarr.uid = 809;
  users.users.radarr.group = "radarr";
  users.users.radarr.extraGroups = ["media"];

  users.groups.sonarr.gid = 810;
  users.users.sonarr.uid = 810;
  users.users.sonarr.group = "sonarr";
  users.users.sonarr.extraGroups = ["media"];

  users.groups.changedetection.gid = 812;
  users.users.changedetection.uid = 812;
  users.users.changedetection.group = "changedetection";

  users.groups.influxdb.gid = 813;
  users.users.influxdb.uid = 813;
  users.users.influxdb.group = "influxdb";

  users.groups.grafana.gid = 814;
  users.users.grafana.uid = 814;
  users.users.grafana.group = "grafana";

  users.groups.traefik.gid = 815;
  users.users.traefik.uid = 815;
  users.users.traefik.group = "traefik";

  users.groups.mosquitto.gid = 1883;
  users.users.mosquitto.uid = 1883;
  users.users.mosquitto.isSystemUser = true;
  users.users.mosquitto.group = "mosquitto";

  users.groups.zigbee2mqtt.gid = 817;
  users.users.zigbee2mqtt.uid = 817;
  users.users.zigbee2mqtt.group = "zigbee2mqtt";

  users.groups.esphome.gid = 818;
  users.users.esphome.uid = 818;
  users.users.esphome.group = "esphome";

  users.groups.paperless.gid = 819;
  users.users.paperless.uid = 819;
  users.users.paperless.group = "paperless";

  users.groups.nginxproxymanager.gid = 820;
  users.users.nginxproxymanager.uid = 820;
  users.users.nginxproxymanager.group = "nginxproxymanager";

  users.groups.watchtower.gid = 821;
  users.users.watchtower.uid = 821;
  users.users.watchtower.group = "watchtower";

  users.groups.authentik.gid = 822;
  users.users.authentik.uid = 822;
  users.users.authentik.group = "authentik";

  users.groups.audiobookshelf.gid = 823;
  users.users.audiobookshelf.uid = 823;
  users.users.audiobookshelf.group = "audiobookshelf";
  users.users.audiobookshelf.extraGroups = ["media"];

  users.groups.dokemon.gid = 824;
  users.users.dokemon.uid = 824;
  users.users.dokemon.group = "dokemon";

  users.groups.readarr.gid = 825;
  users.users.readarr.uid = 825;
  users.users.readarr.group = "readarr";
  users.users.readarr.extraGroups = ["media"];

  users.groups.sshwifty.gid = 826;
  users.users.sshwifty.uid = 826;
  users.users.sshwifty.group = "sshwifty";

  users.groups.gowebserver.gid = 827;
  users.users.gowebserver.uid = 827;
  users.users.gowebserver.group = "gowebserver";

  users.groups.uptimekuma.gid = 828;
  users.users.uptimekuma.uid = 828;
  users.users.uptimekuma.group = "uptimekuma";

  users.groups.immich.gid = 829;
  users.users.immich.uid = 829;
  users.users.immich.group = "immich";
  users.users.immich.extraGroups = ["media"];

  users.groups.flatnotes.gid = 830;
  users.users.flatnotes.uid = 830;
  users.users.flatnotes.group = "flatnotes";

  users.groups.recipya.gid = 831;
  users.users.recipya.uid = 831;
  users.users.recipya.group = "recipya";

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

  #Create directories for docker containers
  systemd.tmpfiles.settings = {
    "directories" = {
      "/docker-data/" = {
        d = {
          group = "root";
          user = "root";
          mode = "0755";
        };
      };
      "/media-data/" = {
        d = {
          group = "root";
          user = "root";
          mode = "0755";
        };
      };
      "/media-data/nas" = {
        d = {
          group = "root";
          user = "root";
          mode = "0755";
        };
      };
      "/media-data/torrents/" = {
        d = {
          group = "media";
          user = "root";
          mode = "0777";
        };
      };
      "/media-data/media/series" = {
        d = {
          group = "media";
          user = "sonarr";
          mode = "0777";
        };
      };
      "/media-data/media/movies" = {
        d = {
          group = "media";
          user = "radarr";
          mode = "0777";
        };
      };
      "/media-data/media/audiobooks" = {
        d = {
          group = "media";
          user = "audiobookshelf";
          mode = "0777";
        };
      };
      "/media-data/media/images" = {
        d = {
          group = "media";
          user = "immich";
          mode = "0777";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pkgs.pwgen
    git
    psmisc
    bind
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  #Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
      6052
      8443
    ];
    allowedUDPPorts = [
      53
      5353
    ];
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = ["ip_tables" "ip6_tables"];
  boot.extraModprobeConfig = "options usbcore autosuspend=-1";

  virtualisation.oci-containers.containers = {
    duplicati = {
      image = "ghcr.io/linuxserver/duplicati:2.1.0";
      environment = {
        PUID = 0;
        PGID = 0;
        TZ = "Europe/Amsterdam";
      };
      volumes = [
        "/docker-data/duplicati/config:/config"
        "/docker-data/duplicati/backups:/backups"
        "/docker-data:/source/docker-data"
        "/etc/nixos/:/source/nixos"
        "/media-data/nas:/source/nas"
      ];
      networks = [traefik-duplicati];
      labels = {
        "wud.tag.include" = "^\d+\.?\d*\.?\d*$";
        "wud.watch" = "true";
        "traefik.enable" = "true";
        "traefik.http.routers.duplicati.rule" = "Host('duplicati.njarling.com')"
        "traefik.docker.network" = "traefik-duplicati"
        "traefik.http.routers.duplicati.middlewares" = "authentik@file"
      };
      ports = [
        "8200" = "8200"
      ];
    };
  };

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

