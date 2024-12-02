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

    home-manager.users.noel = { pkgs, ... }: {
        wayland.windowManager.hyprland = {
            enable = true;
            settings = {
                "$mainMod" = "SUPER";
                bind = [
                    "$mainMod, BackSpace, exec, alacritty"
                    "$mainMod, C, killactive,"
                    "$mainMod, F, fullscreen, 0"
                    "$mainMod, E, exec, nautilus"
                    "$mainMod, X, movetoworkspace, 2"
                    "$mainMod, Y, movetoworkspace, 3"
                    "$mainMod, V, layoutmsg, swapwithmaster"
                    "$mainMod, SPACE, exec, rofi -show drun -show-icons"
                    "$mainMod, M, exec, sh ~/.config/waybar/launch.sh"
                    "$mainMod, j, movefocus, l"
                    "$mainMod, l, movefocus, r"
                    "$mainMod, i, movefocus, u"
                    "$mainMod, k, movefocus, d"
                    "$mainMod ALT, j, movewindow, l"
                    "$mainMod ALT, l, movewindow, r"
                    "$mainMod ALT, i, movewindow, u"
                    "$mainMod ALT, k, movewindow, d"
                ];
                exec-once = [
                    "swaync"
                    "sh ~/.config/waybar/launch.sh"
                    "systemctl --user start hyprpolkitagent"
                ];
                windowrulev2 = [
                    "monitor DP-3,class:.*"
                    "monitor DP-2,class:(steam)"
                    "monitor DP-2,class:(firefox)"
                    "monitor DP-2,class:(Rofi)"
                    "tile,title:(Hyprland Polkit Agent)"
                    "suppressevent maximize, class:.*"
                ];
                workspace = [
                    "2, persistent:true,monitor:DP-2,default:true,layoutopt:orientation:left"
                    "1, persistent:true,monitor:DP-3,default:true,layoutopt:orientation:right"
                ];
                general = {
                    gaps_in = 5;
                    gaps_out = 10;
                    border_size = 2;
                    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                    "col.inactive_border" = "rgba(595959aa)";
                    resize_on_border = false;
                    allow_tearing = true;
                    layout = "master";
                };
                master = {
                    new_status = "master";
                    mfact = 0.66;
                    orientation = "left";
                };
                input = {
                    kb_layout = "de";
                    follow_mouse = 1;
                    sensitivity = "-0.8";
                };
                decoration = {
                    rounding = 10;
                    active_opacity = 1.0;
                    inactive_opacity = 1.0;
                    shadow = {
                        range = 4;
                        render_power = 3;
                        color = "rgba(1a1a1aee)";
                    };
                    blur = {
                        enabled = true;
                        size = 3;
                        passes = 1;
                        vibrancy = 0.1696;
                    };
                };
                animations = {
                    enabled = true;
                    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
                    animation = [
                        "windows, 1, 7, myBezier"
                        "windowsOut, 1, 7, default, popin 80%"
                        "border, 1, 10, default"
                        "borderangle, 1, 8, default"
                        "fade, 1, 7, default"
                        "workspaces, 1, 6, default"
                    ];
                };
                misc = {
                    force_default_wallpaper = 1;
                    disable_hyprland_logo = false;
                };
                monitor = [
                    "DP-2, 2560x1440,1920x0, 1"
                    "DP-3,1920x1080, 0x200, 1"
                    "HDMI-A-1, disable"
                ];
                env = [
                    "XCURSOR_SIZE,24"
                    "HYPRCURSOR_SIZE,24"
                ];
            };
        };
        programs.waybar = {
            enable = true;
            settings = {
                mainBar = {
                    layer = "top";
                    margin-bottom = 0;
                    margin-top = 0;
                    margin-left = 0;
                    margin-right = 0;
                    spacing = 0;
                    modules-left = [
                        "wlr/taskbar"
                        "hyprland/window"
                    ];
                    modules-center = [
                        "hyprland/workspaces"
                    ];
                    modules-right = [
                        "group/hardware"
                        "network"
                        "wireplumber"
                        "bluetooth"
                        "tray"
                        "clock"
                    ];
                    "hyprland/workspaces" = {
                        on-click = "activate";
                        active-only = false;
                        all-outputs = true;
                        special-visible-only = true;
                        format-icons = {
                            urgent = "";
                            active = "";
                            default = "";
                        };
                    };
                    cpu = {
                        format = " {usage}%";
                    };
                    memory = {
                        format = " {used} GiB";
                    };
                    disk = {
                        interval = 60;
                        path = "/";
                        format = " {free}";
                    };
                    "group/hardware" = {
                        orientation = "horizontal";
                        modules = ["cpu" "memory" "disk"];
                    };
                    network = {
                        format-ethernet = " {ipaddr}";
                        format-wifi = " {ipaddr}";
                        format-disconnected = "Not connected";
                        tooltip-format-ethernet = "  {ifname} ({ipaddr}/{cidr})";
                        max-length = 50;
                    };
                    wireplumber = {
                        format = " {volume}%";
                        scroll-step = 5;
                        on-click = "pavucontrol";
                    };
                    bluetooth = {
                        format = " {device_alias}";
                        format-disabled = "";
                        format-off = "";
                        format-no-controller = "";
                        interval = 30;
                        on-click = "bluetoothctl connect CC:08:FA:CB:9D:0A"; #Airpods
                    };
                    tray = {
                        spacing = 10;
                    };
                    clock = {
                        format = "{:%H:%M %a}";
                        tooltip = false;
                    };
                };
            };
            style = ./waybar/style.css;
        };
        home.file.waybar-launch = {
            source = ./waybar/launch.sh;
            target = "./.config/waybar/launch.sh";
        };
        programs.rofi = {
            enable = true;
            theme = builtins.toFile "rofi-theme.rasi" ''
                /* ROUNDED THEME FOR ROFI */
                /* Author: Newman Sanchez (https://github.com/newmanls) */
                * {
                    font:   "Roboto 12";
                    background-color:   transparent;
                    text-color:         @fg0;
                    margin:     0px;
                    padding:    0px;
                    spacing:    0px;
                    bg0:    #2E3440F2;
                    bg1:    #3B4252;
                    bg2:    #4C566A80;
                    bg3:    #88C0D0F2;
                    fg0:    #D8DEE9;
                    fg1:    #ECEFF4;
                    fg2:    #D8DEE9;
                    fg3:    #4C566A;
                }

                window {
                    location:       north;
                    y-offset:       calc(50% - 176px);
                    width:          480;
                    border-radius:  24px;
                    background-color:   @bg0;
                }

                mainbox {
                    padding:    12px;
                }

                inputbar {
                    background-color:   @bg1;
                    border-color:       @bg3;
                    border:         2px;
                    border-radius:  16px;
                    padding:    8px 16px;
                    spacing:    8px;
                    children:   [ prompt, entry ];
                }

                prompt {
                    text-color: @fg2;
                }

                entry {
                    placeholder:        "Search";
                    placeholder-color:  @fg3;
                }

                message {
                    margin:             12px 0 0;
                    border-radius:      16px;
                    border-color:       @bg2;
                    background-color:   @bg2;
                }

                textbox {
                    padding:    8px 24px;
                }

                listview {
                    background-color:   transparent;

                    margin:     12px 0 0;
                    lines:      8;
                    columns:    1;

                    fixed-height: false;
                }

                element {
                    padding:        8px 16px;
                    spacing:        8px;
                    border-radius:  16px;
                }

                element normal active {
                    text-color: @bg3;
                }

                element alternate active {
                    text-color: @bg3;
                }

                element selected normal, element selected active {
                    background-color:   @bg3;
                }

                element-icon {
                    size:           1em;
                    vertical-align: 0.5;
                }

                element-text {
                    text-color: inherit;
                }

                element selected {
                    text-color: @bg1;
                }
            '';
        };
    };
}
