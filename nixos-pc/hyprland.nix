{config, pkgs, ...}:
{
    environment.systemPackages = with pkgs; [
        waybar # Wayland System Bar
        rofi-wayland
        swaynotificationcenter
        waybar
        hyprpolkitagent
        pavucontrol
        hyprland
        hyprpaper
        cava
    ];
    fonts.packages = with pkgs; [
        font-awesome
        fira-sans
    ];

    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    home-manager.backupFileExtension = "backup";
    home-manager.users.noel = { config, pkgs, ... }: {
        home.file = {
            ".config/hypr" = {
                recursive = true;
                source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-pc/config/hypr";
            };
            ".config/waybar" = {
                recursive = true;
                source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-pc/config/waybar";
            };
            ".config/rofi" = {
                recursive = true;
                source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-pc/config/rofi";
            };
        };
    };
}
