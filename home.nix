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
			tmuxPlugins.catppuccin
		];
		extraConfig = ''
			set -g @catppuccin_flavour "mocha"
			set -g @catppuccin_window_status_style "rounded"
			set -g status-right-length 100
			set -g status-left-length 100
			set -g status-left ""
			set -g status-right "#{E:@catppuccin_status_application}"
			set -agF status-right "#{E:@catppuccin_status_cpu}"
			set -ag status-right "#{E:@catppuccin_status_session}"
			set -ag status-right "#{E:@catppuccin_status_uptime}"
			set -agF status-right "#{E:@catppuccin_status_battery}"
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
			# config = ''
			# 	colorscheme solarized-osaka
			# '';
		}

		{
			plugin = catppuccin-nvim;
			config = ''
				colorscheme catppuccin-mocha
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

	wayland.windowManager.hyprland.package = null;

# 	wayland.windowManager.hyprland = {
# 		enable = true;
# 		settings = {
# 			"$mainMod" = "SUPER";
# 		};
# 		extraConfig = ''
# 		monitor=,preferred,auto,1.0
# # monitor=eDP-1,1920x1080@60,0x0,1.0
#
#
# ###################
# ### MY PROGRAMS ###
# ###################
#
# # See https://wiki.hyprland.org/Configuring/Keywords/
#
# # Set programs that you use
# $terminal = kitty
# $fileManager = dolphin
# $menu = noctalia-shell ipc call launcher toggle
# $snip = hyprshot --clipboard-only -m region
#
#
# #################
# ### AUTOSTART ###
# #################
#
# # Autostart necessary processes (like notifications daemons, status bars, etc.)
# # Or execute your favorite apps at launch like this:
#
# # exec-once = $terminal
# # exec-once = nm-applet &
# exec-once = noctalia-shell 
#
#
# #############################
# ### ENVIRONMENT VARIABLES ###
# #############################
#
# # See https://wiki.hyprland.org/Configuring/Environment-variables/
# env = GTK_THEME,Tokyo-Night-Dark
# env = GTK_ICON_THEME,Adwaita
#
# env = XCURSOR_SIZE,24
# env = HYPRCURSOR_SIZE,24
# env = XDG_CURRENT_DESKTOP,Hyprland
# env = XDG_SESSION_TYPE,wayland
#
#
# #####################
# ### LOOK AND FEEL ###
# #####################
#
# # Refer to https://wiki.hyprland.org/Configuring/Variables/
#
# # https://wiki.hyprland.org/Configuring/Variables/#general
# general {
#     gaps_in = 2
#     gaps_out = 2
#     border_size = 1
#
#     col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
#     col.inactive_border = rgba(595959aa)
#
#     resize_on_border = false
#     allow_tearing = false
#
#     layout = dwindle
# }
#
#
# # https://wiki.hyprland.org/Configuring/Variables/#decoration
# decoration {
#     rounding = 0
#     rounding_power = 0
#
#     # Change transparency of focused and unfocused windows
#     active_opacity = 1.0
#     inactive_opacity = 1.0
#
#
#     # https://wiki.hyprland.org/Configuring/Variables/#blur
#     blur {
#         enabled = true
#         size = 3
#         passes = 1
#
#         vibrancy = 0.1696
#     }
# }
#
# # https://wiki.hyprland.org/Configuring/Variables/#animations
# animations {
#     enabled = true
#
#     # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
#
#     bezier = myBezier, 0.05, 0.9, 0.1, 1.05
#
#     animation = windows, 1, 7, myBezier
#     animation = windowsOut, 1, 7, default, popin 80%
#     animation = border, 1, 10, default
#     animation = borderangle, 1, 8, default
#     animation = fade, 1, 7, default
#     animation = workspaces, 1, 6, default
# }
#
# # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
# dwindle {
#     pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
#     preserve_split = true # You probably want this
# }
#
# # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
# master {
#     new_status = master
# }
#
# # https://wiki.hyprland.org/Configuring/Variables/#misc
# misc { 
#     force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
#     disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
# }
#
#
# #############
# ### INPUT ###
# #############
#
# # https://wiki.hyprland.org/Configuring/Variables/#input
# input {
#     kb_layout = us
#     kb_variant =
#     kb_model =
#     kb_options =
#     kb_rules =
#
#     follow_mouse = 1
#
#     sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
#
#     #xset r rate 200 35
#     repeat_rate = 35
#     repeat_delay = 200
#
#
#     touchpad {
#         natural_scroll = false
#     }
# }
#
# cursor {
#     inactive_timeout = 30
#     no_hardware_cursors = true
# }
#
#
# # Example per-device config
# # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
# device {
#     name = epic-mouse-v1
#     sensitivity = -0.5
# }
#
#
# ####################
# ### KEYBINDINGSS ###
# ####################
#
# # See https://wiki.hyprland.org/Configuring/Keywords/
# $mainMod = SUPER # Sets "Windows" key as main modifier
#
# # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
# bind = $mainMod, Return, exec, $terminal
# bind = $mainMod, Q, killactive,
# bind = $mainMod, M, exit,
# bind = $mainMod, E, exec, $fileManager
# bind = $mainMod, V, togglefloating,
# bind = $mainMod, D, exec, $menu
# bind = $mainMod, R, exec, $reload_waybar
# bind = $mainMod, S, exec, $snip
#
# # Move focus with mainMod + arrow keys
# bind = $mainMod, l, movefocus, l
# bind = $mainMod, h, movefocus, r
# bind = $mainMod, k, movefocus, u
# bind = $mainMod, j, movefocus, d
#
# # Switch workspaces with mainMod + [0-9]
# bind = $mainMod, 1, workspace, 1
# bind = $mainMod, 2, workspace, 2
# bind = $mainMod, 3, workspace, 3
# bind = $mainMod, 4, workspace, 4
# bind = $mainMod, 5, workspace, 5
# bind = $mainMod, 6, workspace, 6
# bind = $mainMod, 7, workspace, 7
# bind = $mainMod, 8, workspace, 8
# bind = $mainMod, 9, workspace, 9
# bind = $mainMod, 0, workspace, 10
#
# # Move active window to a workspace with mainMod + SHIFT + [0-9]
# bind = $mainMod SHIFT, 1, movetoworkspace, 1
# bind = $mainMod SHIFT, 2, movetoworkspace, 2
# bind = $mainMod SHIFT, 3, movetoworkspace, 3
# bind = $mainMod SHIFT, 4, movetoworkspace, 4
# bind = $mainMod SHIFT, 5, movetoworkspace, 5
# bind = $mainMod SHIFT, 6, movetoworkspace, 6
# bind = $mainMod SHIFT, 7, movetoworkspace, 7
# bind = $mainMod SHIFT, 8, movetoworkspace, 8
# bind = $mainMod SHIFT, 9, movetoworkspace, 9
# bind = $mainMod SHIFT, 0, movetoworkspace, 10
#
# # Example special workspace (scratchpad)
# # bind = $mainMod, S, togglespecialworkspace, magic
# # bind = $mainMod SHIFT, S, movetoworkspace, special:magic
#
# # Scroll through existing workspaces with mainMod + scroll
# bind = $mainMod, mouse_down, workspace, e+1
# bind = $mainMod, mouse_up, workspace, e-1
#
# # Move/resize windows with mainMod + LMB/RMB and dragging
# bindm = $mainMod, mouse:272, movewindow
# bindm = $mainMod, mouse:273, resizewindow
#
#
# ##############################
# ### WINDOWS AND WORKSPACES ###
# ##############################
#
# # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
# # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
#
# # Example windowrule v1
# # windowrule = float, ^(kitty)$
#
# # Example windowrule v2
# # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
#
# windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.
#
# 		'';
# 	};
	# xdg.configFile."hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;

	home.file = {
	  ".config/niri".source = ./config/niri;
	  ".config/hypr".source = ./config/hypr;
	};

	home.sessionVariables = {
		EDITOR = "nvim";
	};

	programs.home-manager.enable = true;
}
