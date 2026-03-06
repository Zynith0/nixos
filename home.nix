{ config, pkgs, ... }:

{
	home.username = "zynith";
	home.homeDirectory = "/home/zynith";

	home.stateVersion = "25.11"; # Please read the comment before changing.

	home.packages = [
	];

	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo test";
		};
	};

	programs.zsh = {
		enable = true;
		oh-my-zsh = {
			enable = true;
			theme = "robbyrussell";
			plugins = [ "git" "docker" ];
		};
		shellAliases = {
			nixrs = "sudo nixos-rebuild switch";
			vim = "nvim";
		};
		# initContent = ''
		# 	unimatrix -w -s 98 -c blue -i -f
		# '';
	};

	programs.fzf = {
		enable = true;
		enableZshIntegration = true;
	};

	programs.git = {
		enable = true;
		userName = "Zynith0";
		userEmail = "nolan.lessard.music@gmail.com";
	};

	programs.vicinae = {
		enable = true;
		systemd.enable = true;
	};

	programs.tmux =	{
		enable = true;

		baseIndex = 1;
		prefix = "C-o";

		plugins = with pkgs; [
			# tmuxPlugins.rose-pine
			tmuxPlugins.catppuccin
		];
		extraConfig = ''
			set -g @catppuccin_flavour 'mocha'
		'';
	};

	programs.neovim =
	let
		toLua = str: "lua << EOF\n${str}\nEOF\n";
		toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
	in 
	{
		enable = true;
		extraConfig = toLua ''
			vim.g.mapleader = " "

			vim.keymap.set("n", "<leader>pv", "<cmd>Explore<CR>")

			vim.keymap.set("n", "<leader>vca", function()
					vim.lsp.buf.code_action()
			end)

			vim.keymap.set("n", "<leader>vrn", function()
					vim.lsp.buf.rename()
			end)

		
			vim.diagnostic.config({ virtual_text = true })
			vim.o.tabstop = 4
			vim.o.shiftwidth = 4
			vim.o.guicursor = ""
			vim.o.number = true
			vim.o.relativenumber = true

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {"go"},
				callback = function(ev)
					vim.treesitter.start()
				end
			})
		'';
		plugins = with pkgs.vimPlugins; [
		{
			plugin = gruvbox-nvim;
			# config = "colorscheme gruvbox";
		}

		{
			plugin = tokyonight-nvim;
			# config = "colorscheme tokyonight";
		}

		{
			plugin = nvim-lspconfig;
			config = toLua ''
				vim.lsp.enable("lua_ls")
				vim.lsp.enable("gopls")
				vim.lsp.enable("rust_analyzer")
				vim.lsp.enable("hls")
				vim.lsp.config["qmlls"] = {
					cmd = { "qmlls6" },
					filetypes = { "qml" },
					root_markers = { ".git" },
				}
				vim.lsp.enable("qmlls")
				vim.lsp.enable("clangd")
				vim.lsp.enable("ty")
				vim.lsp.enable("pyright")
				vim.lsp.enable("superhtml")
				vim.lsp.enable("harper_ls")
				vim.lsp.enable("astro")
				vim.lsp.enable("tailwindcss")
				vim.lsp.enable("ols")
				vim.lsp.enable("nil_ls")
			'';
		}

		{
			plugin = blink-cmp;
			config = toLua ''
			   require('blink.cmp').setup({
				   keymap = { preset = 'enter' },

				   appearance = {
					   nerd_font_variant = 'mono'
				   },

				   completion = { documentation = { auto_show = true } },

				   sources = {
					   default = { 'lsp', 'path', 'snippets', 'buffer' },
				   },
				   opts_extend = { "sources.default" }
			   })
			   '';
		}

		{
			plugin = telescope-nvim;
			config = toLua ''
				vim.g.mapleader = " "
				vim.keymap.set("n", "<leader>pf", "<cmd>Telescope find_files<CR>")
			'';
		}

		{
			plugin = everforest;
			config = ''
			let g:everforest_colors_override = {'bg0': ["", '234']}
			'';
		}

		{
			plugin = trouble-nvim;
			config = toLua ''
				vim.keymap.set("n", "<leader>et", function()
					require("trouble").toggle("diagnostics")
				end)
			'';
		}

		{
			plugin = render-markdown-nvim;
		}

		{
			plugin = rose-pine;
			# config = ''
			# 	colorscheme rose-pine
			# '';
		}

		{
			plugin = nightfox-nvim;
			# config = ''
			# 	colorscheme terafox
			# '';
		}

		{
			plugin = emmet-vim;
		}

		{
			plugin = nvim-ts-autotag;
		}

		{
			plugin = nvim-autopairs;
			config = toLua ''
				require("nvim-autopairs").setup({})
			'';
		}

		{
			plugin = solarized-osaka-nvim;
			config = ''
				colorscheme solarized-osaka
			'';
		}

		(nvim-treesitter.withPlugins (p: [
			  p.go
			  p.rust
			  p.astro
			  p.gleam
			  p.nix
		]))

		];
	};

	wayland.windowManager.hyprland = {
		enable = true;
		settings = {
			"$mainMod" = "SUPER";
		};
		extraConfig = ''
		source = noctalia/noctalia-colors.conf

		################
		### MONITORS ###
		################

		# See https://wiki.hypr.land/Configuring/Monitors/
		monitor=DP-1,1920x1080@144,1920x0,1
		monitor=HDMI-A-1,1920x1080@75,0x0,1


		###################
		### MY PROGRAMS ###
		###################

		# See https://wiki.hypr.land/Configuring/Keywords/

		# Set programs that you use
		$terminal = kitty
		$fileManager = nemo
		# $menu = noctalia-shell ipc call launcher toggle
		$menu = vicinae open
		$browser = librewolf


		#################
		### AUTOSTART ###
		#################

		# Autostart necessary processes (like notifications daemons, status bars, etc.)
		# Or execute your favorite apps at launch like this:

		# exec-once = $terminal
		# exec-once = nm-applet &
		# exec-once = waybar & hyprpaper & firefox
		# exec-once = swww-daemon
		# exec-once = quickshell
		# exec-once = swaync -s ~/.config/swaync/style.css
		exec-once = hyprctl dispatch workspace 1
		exec-once = noctalia-shell
		exec-once = mpv --no-input-default-bindings --osc=no --fullscreen --on-all-workspaces ~/The\ GabeCube\ Steam\ Deck\ Boot\ Animation\ \[y1gWFcU3Qm0\].mp4


		#############################
		### ENVIRONMENT VARIABLES ###
		#############################

		# See https://wiki.hypr.land/Configuring/Environment-variables/

		env = XCURSOR_SIZE,24
		env = XCURSOR_THEME,DMZ (White)
		env = HYPRCURSOR_SIZE,24
		env = HYPRCURSOR_THEME,DMZ


		###################
		### PERMISSIONS ###
		###################

		# See https://wiki.hypr.land/Configuring/Permissions/
		# Please note permission changes here require a Hyprland restart and are not applied on-the-fly
		# for security reasons

		# ecosystem {
		#   enforce_permissions = 1
		# }

		# permission = /usr/(bin|local/bin)/grim, screencopy, allow
		# permission = /usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow
		# permission = /usr/(bin|local/bin)/hyprpm, plugin, allow


		#####################
		### LOOK AND FEEL ###
		#####################

		# Refer to https://wiki.hypr.land/Configuring/Variables/

		# https://wiki.hypr.land/Configuring/Variables/#general
		general {
			gaps_in = 5
			gaps_out = 5
			# gaps_in = 0
			# gaps_out = 0

			border_size = 2

			# https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
			col.active_border = $primary
			col.inactive_border = rgba(595959aa)

			# Set to true enable resizing windows by clicking and dragging on borders and gaps
			resize_on_border = false

			# Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
			allow_tearing = false

			layout = dwindle
		}

		# https://wiki.hypr.land/Configuring/Variables/#decoration
		decoration {
			rounding = 10
			rounding_power = 2
			# rounding = 0
			# rounding_power = 0

			# Change transparency of focused and unfocused windows
			active_opacity = 1.0
			inactive_opacity = 0.7

			shadow {
				enabled = true
				range = 4
				render_power = 3
				color = rgba(1a1a1aee)
			}

			# https://wiki.hypr.land/Configuring/Variables/#blur
			blur {
				enabled = true
				size = 3
				passes = 4

				vibrancy = 0.1696
			}
		}

		# https://wiki.hypr.land/Configuring/Variables/#animations

		$interval=6.9
		$curve=easeOut

		animations {
			enabled = yes, please :)
			# enabled = no, please :)

			# Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
			#        NAME,           X0,   Y0,   X1,   Y1
			bezier = easeOutQuint,   0.23, 1,    0.32, 1
			bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
			bezier = linear,         0,    0,    1,    1
			bezier = almostLinear,   0.5,  0.5,  0.75, 1
			bezier = quick,          0.15, 0,    0.1,  1
			bezier = bounce,         0.23, 1.2,    0.32, 1.2
			bezier = miniBounce,         0.23, 1.06,    0.32, 1.06
			bezier = easeOut, 0.16, 1, 0.3, 1

			# Default animations, see https://wiki.hypr.land/Configuring/Animations/
			#           NAME,          ONOFF, SPEED, CURVE,        [STYLE]
			animation = global,        1,     10,    default
			animation = border,        1,     5.39,  easeOutQuint
			animation = windows,       1,     $interval,  $curve, slide
			animation = windowsIn,     1,     $interval,   $curve, popin 90%
			animation = windowsOut,    1,     $interval,  $curve, popin 80%
			animation = fadeIn,        1,     1.73,  almostLinear
			animation = fadeOut,       1,     1.46,  almostLinear
			animation = fade,          1,     3.03,  quick
			animation = layers,        1,     3.81,  easeOutQuint
			animation = layersIn,      1,     4,     easeOutQuint, fade
			animation = layersOut,     1,     1.5,   linear,       fade
			animation = fadeLayersIn,  1,     1.79,  almostLinear
			animation = fadeLayersOut, 1,     1.39,  almostLinear
			animation = workspaces,    1,     1.94,  easeOutQuint, slidefadevert
			animation = workspacesIn,  1,     1.21,  easeOutQuint, slidefadevert
			animation = workspacesOut, 1,     1.94,  easeOutQuint, slidefadevert
			animation = zoomFactor,    1,     7,     quick
		}

		# Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
		# "Smart gaps" / "No gaps when only"
		# uncomment all if you wish to use that.
		# workspace = w[tv1], gapsout:0, gapsin:0
		# workspace = f[1], gapsout:0, gapsin:0
		# windowrule {
		#     name = no-gaps-wtv1
		#     match:float = false
		#     match:workspace = w[tv1]
		#
		#     border_size = 0
		#     rounding = 0
		# }
		#
		# windowrule {
		#     name = no-gaps-f1
		#     match:float = false
		#     match:workspace = f[1]
		#
		#     border_size = 0
		#     rounding = 0
		# }

		# See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
		dwindle {
			pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
			preserve_split = true # You probably want this
		}

		# See https://wiki.hypr.land/Configuring/Master-Layout/ for more
		master {
			new_status = master
		}

		# https://wiki.hypr.land/Configuring/Variables/#misc
		misc {
			force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
			disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
		}


		#############
		### INPUT ###
		#############

		# https://wiki.hypr.land/Configuring/Variables/#input
		input {
			kb_layout = us,us
			kb_variant = dvorak,
			kb_model =
			kb_options = grp:alt_shift_toggle
			kb_rules =

			follow_mouse = 1

			sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

			touchpad {
				natural_scroll = false
			}
			resolve_binds_by_sym = 1
		}

		# See https://wiki.hypr.land/Configuring/Gestures
		# gesture = 3, horizontal, workspace

		# Example per-device config
		# See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs for more
		device {
			name = epic-mouse-v1
			sensitivity = -0.5
		}


		###################
		### KEYBINDINGS ###
		###################

		# Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
		bind = SUPER, RETURN, exec, $terminal
		bind = SUPER, Q, killactive,
		bind = SUPER_SHIFT, X, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit
		bind = SUPER, E, exec, $fileManager
		bind = SUPER, V, togglefloating,
		bind = SUPER, R, exec, $menu
		bind = SUPER, SPACE, exec, $menu
		bind = SUPER, B, exec, $browser
		bind = SUPER, P, pseudo, # dwindle
		bind = SUPER, F, fullscreen
		bind = SUPER, T, exec, swaync-client -t
		bind = SUPER, S, exec, hyprshot --clipboard-only -m region
		bind = SUPER, U, exec, noctalia-shell ipc call lockScreen lock
		bind = SUPER_SHIFT, Y, exec, noctalia-shell ipc call wallpaper toggle
		bind = SUPER_SHIFT, P, exec, hyprpicker -a -l
		bind = SUPER_SHIFT, S, exec, pactl set-default-sink 74
		bind = SUPER_SHIFT, E, exec, pactl set-default-sink 70
		# Move SUPERth mainMod + arrow keys
		bind = SUPER, H, movefocus, l
		bind = SUPER, J, movefocus, d
		bind = SUPER, K, movefocus, u
		bind = SUPER, L, movefocus, r

		# Move window with mainMod + Shift + arrow keys
		bind = SUPER_SHIFT, H, movewindow, l
		bind = SUPER_SHIFT, J, movewindow, d
		bind = SUPER_SHIFT, K, movewindow, u
		bind = SUPER_SHIFT, L, movewindow, r

		# Switch workspaces with mainMod + [0-9]
		bind = SUPER, 1, exec, ~/.config/hypr/scripts/workspace_switch.sh 1
		bind = SUPER, 2, exec, ~/.config/hypr/scripts/workspace_switch.sh 2
		bind = SUPER, 3, exec, ~/.config/hypr/scripts/workspace_switch.sh 3
		bind = SUPER, 4, exec, ~/.config/hypr/scripts/workspace_switch.sh 4
		bind = SUPER, 5, exec, ~/.config/hypr/scripts/workspace_switch.sh 5
		bind = SUPER, 6, exec, ~/.config/hypr/scripts/workspace_switch.sh 6
		bind = SUPER, 7, exec, ~/.config/hypr/scripts/workspace_switch.sh 7
		bind = SUPER, 8, exec, ~/.config/hypr/scripts/workspace_switch.sh 8
		bind = SUPER, 9, exec, ~/.config/hypr/scripts/workspace_switch.sh 9
		bind = SUPER, 0, exec, ~/.config/hypr/scripts/workspace_switch.sh 10

		# Move active window to a workspace with mainMod + SHIFT + [0-9]
		bind = SUPER_SHIFT, 1, movetoworkspace, 1
		bind = SUPER_SHIFT, 2, movetoworkspace, 2
		bind = SUPER_SHIFT, 3, movetoworkspace, 3
		bind = SUPER_SHIFT, 4, movetoworkspace, 4
		bind = SUPER_SHIFT, 5, movetoworkspace, 5
		bind = SUPER_SHIFT, 6, movetoworkspace, 6
		bind = SUPER_SHIFT, 7, movetoworkspace, 7
		bind = SUPER_SHIFT, 8, movetoworkspace, 8
		bind = SUPER_SHIFT, 9, movetoworkspace, 9
		bind = SUPER_SHIFT, 0, movetoworkspace, 10

		# Example special workspace (scratchpad)
		# bind = SUPER, S, togglespecialworkspace, magic
		# bind = SUPER_SHIFT, S, movetoworkspace, special:magic

		# Scroll through existing workspaces with mainMod + scroll
		# bind = SUPER, mouse_down, workspace, e+1
		# bind = SUPER, mouse_up, workspace, e-1

		# Move/resize windows with mainMod + LMB/RMB and dragging
		bindm = SUPER, mouse:272, movewindow
		bindm = SUPER, mouse:273, resizewindow

		# bind = $mainMod, mouse_down, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')
		# bind = $mainMod, mouse_up, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 0.9')

		# Laptop multimedia keys for volume and LCD brightness
		bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
		bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
		bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
		bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
		bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
		bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

		# Requires playerctl
		bindl = , XF86AudioNext, exec, playerctl next
		bindl = , XF86AudioPause, exec, playerctl play-pause
		bindl = , XF86AudioPlay, exec, playerctl play-pause
		bindl = , XF86AudioPrev, exec, playerctl previous

		##############################
		### WINDOWS AND WORKSPACES ###
		##############################

		# See https://wiki.hypr.land/Configuring/Window-Rules/ for more
		# See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

		# Example windowrules that are useful

		# windowrule {
		#     # Ignore maximize requests from all apps. You'll probably like this.
		#     name = suppress-maximize-events
		#     match:class = .*
		#
		#     suppress_event = maximize
		# }
		#
		# windowrule {
		#     # Fix some dragging issues with XWayland
		#     name = fix-xwayland-drags
		#     match:class = ^$
		#     match:title = ^$
		#     match:xwayland = true
		#     match:float = true
		#     match:fullscreen = false
		#     match:pin = false
		#
		#     no_focus = true
		# }
		#
		# # Hyprland-run windowrule
		# windowrule {
		#     name = move-hyprland-run
		#
		#     match:class = hyprland-run
		#
		#     move = 20 monitor_h-120
		#     float = yes
		# }

		# windowrule = match:class mpv, float on
		# windowrule = match:class mpv, no_anim on

		# layerrule = match:namespace rofi, animation popin
		# layerrule = match:namespace fuzzel, animation popin
		# layerrule = match:namespace quickshell, blur true
		# layerrule = match:namespace quickshell, ignore_alpha 0 
		# layerrule = match:namespace swaync-control-center, blur true 
		# layerrule = match:namespace vicinae blur true 
		# layerrule = match:namespace vicinae ignore_alpha 0
		# layerrule = match:namespace swaync-control-center, ignore_alpha 0
		# layerrule = match:namespace swaync-control-center, animation slide right
		# layerrule {
		# 	name = noctalia
		# 	match:namespace = noctalia-background-.*$
		# 	ignore_alpha = 0.5
		# 	blur = true
		# 	blur_popups = true
		# }
		'';
	};

	home.file.".config/niri".source = ./config/niri;

	# home.file = {
	# };

	home.sessionVariables = {
		EDITOR = "nvim";
	};

	programs.home-manager.enable = true;
}
