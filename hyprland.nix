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
                    "$mainMod, Y, movetoworkspace, 1"
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
                    ", code:123, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                    ", code:122, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                ];
                exec-once = [
                    "swaync"
                    "sh ~/.config/waybar/launch.sh"
                    "systemctl --user start hyprpolkitagent"
                ];
                windowrulev2 = [
                    #"monitor DP-3,class:.*"
                    #"monitor DP-2,class:(steam)"
                    "monitor DP-2,class:(firefox)"
                    "monitor DP-2,class:(Rofi)"
                    "monitor DP-3,class:War Thunder \(Vulkan, 64bit\)"
                    "fullscreen,class:(War Thunder \(Vulkan, 64bit\))"
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
                    "ELECTRON_OZONE_PLATFORM_HINT,auto"
                    "HYPRCURSOR_SIZE,24"
                    "QT_QPA_PLATFORM,wayland"
                    "QT_QPA_PLATFORMTHEME,qt5ct"
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
                configuration {
	modi:                       "drun,run,filebrowser,window";
    show-icons:                 true;
    display-drun:               "";
    display-run:                "";
    display-filebrowser:        "";
    display-window:             "";
	drun-display-format:        "{name}";
	window-format:              "{w} · {c} · {t}";
}

/*****----- Global Properties -----*****/
//@import "~/.config/rofi/colors/onedark.rasi"

* {
    font: "JetBrains Mono Nerd Font 10";
}

* {
    border-colour:               var(selected);
    handle-colour:               var(selected);
    background-colour:           var(background);
    foreground-colour:           var(foreground);
    alternate-background:        var(background-alt);
    normal-background:           var(background);
    normal-foreground:           var(foreground);
    urgent-background:           var(urgent);
    urgent-foreground:           var(background);
    active-background:           var(active);
    active-foreground:           var(background);
    selected-normal-background:  var(selected);
    selected-normal-foreground:  var(background);
    selected-urgent-background:  var(active);
    selected-urgent-foreground:  var(background);
    selected-active-background:  var(urgent);
    selected-active-foreground:  var(background);
    alternate-normal-background: var(background);
    alternate-normal-foreground: var(foreground);
    alternate-urgent-background: var(urgent);
    alternate-urgent-foreground: var(background);
    alternate-active-background: var(active);
    alternate-active-foreground: var(background);
}

/*****----- Main Window -----*****/
window {
    /* properties for window widget */
    transparency:                "real";
    location:                    center;
    anchor:                      center;
    fullscreen:                  false;
    width:                       600px;
    x-offset:                    0px;
    y-offset:                    0px;

    /* properties for all widgets */
    enabled:                     true;
    margin:                      0px;
    padding:                     0px;
    border:                      0px solid;
    border-radius:               10px;
    border-color:                @border-colour;
    cursor:                      "default";
    /* Backgroud Colors */
    background-color:            @background-colour;
    /* Backgroud Image */
    //background-image:          url("/path/to/image.png", none);
    /* Simple Linear Gradient */
    //background-image:          linear-gradient(red, orange, pink, purple);
    /* Directional Linear Gradient */
    //background-image:          linear-gradient(to bottom, pink, yellow, magenta);
    /* Angle Linear Gradient */
    //background-image:          linear-gradient(45, cyan, purple, indigo);
}

/*****----- Main Box -----*****/
mainbox {
    enabled:                     true;
    spacing:                     10px;
    margin:                      0px;
    padding:                     30px;
    border:                      0px solid;
    border-radius:               0px 0px 0px 0px;
    border-color:                @border-colour;
    background-color:            transparent;
    children:                    [ "inputbar", "message", "listview" ];
}

/*****----- Inputbar -----*****/
inputbar {
    enabled:                     true;
    spacing:                     10px;
    margin:                      0px;
    padding:                     0px;
    border:                      0px solid;
    border-radius:               0px;
    border-color:                @border-colour;
    background-color:            transparent;
    text-color:                  @foreground-colour;
    children:                    [ "textbox-prompt-colon", "entry", "mode-switcher" ];
}

prompt {
    enabled:                     true;
    background-color:            inherit;
    text-color:                  inherit;
}
textbox-prompt-colon {
    enabled:                     true;
    padding:                     5px 0px;
    expand:                      false;
    str:                         "";
    background-color:            inherit;
    text-color:                  inherit;
}
entry {
    enabled:                     true;
    padding:                     5px 0px;
    background-color:            inherit;
    text-color:                  inherit;
    cursor:                      text;
    placeholder:                 "Search...";
    placeholder-color:           inherit;
}
num-filtered-rows {
    enabled:                     true;
    expand:                      false;
    background-color:            inherit;
    text-color:                  inherit;
}
textbox-num-sep {
    enabled:                     true;
    expand:                      false;
    str:                         "/";
    background-color:            inherit;
    text-color:                  inherit;
}
num-rows {
    enabled:                     true;
    expand:                      false;
    background-color:            inherit;
    text-color:                  inherit;
}
case-indicator {
    enabled:                     true;
    background-color:            inherit;
    text-color:                  inherit;
}

/*****----- Listview -----*****/
listview {
    enabled:                     true;
    columns:                     1;
    lines:                       8;
    cycle:                       true;
    dynamic:                     true;
    scrollbar:                   true;
    layout:                      vertical;
    reverse:                     false;
    fixed-height:                true;
    fixed-columns:               true;
    
    spacing:                     5px;
    margin:                      0px;
    padding:                     0px;
    border:                      0px solid;
    border-radius:               0px;
    border-color:                @border-colour;
    background-color:            transparent;
    text-color:                  @foreground-colour;
    cursor:                      "default";
}
scrollbar {
    handle-width:                5px ;
    handle-color:                @handle-colour;
    border-radius:               10px;
    background-color:            @alternate-background;
}

/*****----- Elements -----*****/
element {
    enabled:                     true;
    spacing:                     10px;
    margin:                      0px;
    padding:                     5px 10px;
    border:                      0px solid;
    border-radius:               10px;
    border-color:                @border-colour;
    background-color:            transparent;
    text-color:                  @foreground-colour;
    cursor:                      pointer;
}
element normal.normal {
    background-color:            var(normal-background);
    text-color:                  var(normal-foreground);
}
element normal.urgent {
    background-color:            var(urgent-background);
    text-color:                  var(urgent-foreground);
}
element normal.active {
    background-color:            var(active-background);
    text-color:                  var(active-foreground);
}
element selected.normal {
    background-color:            var(selected-normal-background);
    text-color:                  var(selected-normal-foreground);
}
element selected.urgent {
    background-color:            var(selected-urgent-background);
    text-color:                  var(selected-urgent-foreground);
}
element selected.active {
    background-color:            var(selected-active-background);
    text-color:                  var(selected-active-foreground);
}
element alternate.normal {
    background-color:            var(alternate-normal-background);
    text-color:                  var(alternate-normal-foreground);
}
element alternate.urgent {
    background-color:            var(alternate-urgent-background);
    text-color:                  var(alternate-urgent-foreground);
}
element alternate.active {
    background-color:            var(alternate-active-background);
    text-color:                  var(alternate-active-foreground);
}
element-icon {
    background-color:            transparent;
    text-color:                  inherit;
    size:                        24px;
    cursor:                      inherit;
}
element-text {
    background-color:            transparent;
    text-color:                  inherit;
    highlight:                   inherit;
    cursor:                      inherit;
    vertical-align:              0.5;
    horizontal-align:            0.0;
}

/*****----- Mode Switcher -----*****/
mode-switcher{
    enabled:                     true;
    spacing:                     10px;
    margin:                      0px;
    padding:                     0px;
    border:                      0px solid;
    border-radius:               0px;
    border-color:                @border-colour;
    background-color:            transparent;
    text-color:                  @foreground-colour;
}
button {
    padding:                     5px 10px;
    border:                      0px solid;
    border-radius:               10px;
    border-color:                @border-colour;
    background-color:            @alternate-background;
    text-color:                  inherit;
    cursor:                      pointer;
}
button selected {
    background-color:            var(selected-normal-background);
    text-color:                  var(selected-normal-foreground);
}

/*****----- Message -----*****/
message {
    enabled:                     true;
    margin:                      0px;
    padding:                     0px;
    border:                      0px solid;
    border-radius:               0px 0px 0px 0px;
    border-color:                @border-colour;
    background-color:            transparent;
    text-color:                  @foreground-colour;
}
textbox {
    padding:                     8px 10px;
    border:                      0px solid;
    border-radius:               10px;
    border-color:                @border-colour;
    background-color:            @alternate-background;
    text-color:                  @foreground-colour;
    vertical-align:              0.5;
    horizontal-align:            0.0;
    highlight:                   none;
    placeholder-color:           @foreground-colour;
    blink:                       true;
    markup:                      true;
}
error-message {
    padding:                     10px;
    border:                      2px solid;
    border-radius:               10px;
    border-color:                @border-colour;
    background-color:            @background-colour;
    text-color:                  @foreground-colour;
}
            '';
        };
    };
}
