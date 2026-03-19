{ config, pkgs, ... }:

{
	home.username = "zynith";
	home.homeDirectory = "/home/zynith";

	home.stateVersion = "25.11";

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

	programs = {
		nushell = {
			enable = true;
			extraConfig = ''
				$env.config.show_banner = false
			'';
			shellAliases = {
				vim = "nvim";
			};
		};
		starship = {
			enable = true;
			settings = {
				add_newline = true;
				# character = {
				# 	success_symbol = "[➜](bold green)";
				# 	error_symbol = "[➜](bold red)";
				# };
				format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
				character = {
					success_symbol = "[](bold green) ";
					error_symbol = "[✗](bold red) ";
				};
			};
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

	# programs.neovim =
	# let
	# 	toLua = str: "lua << EOF\n${str}\nEOF\n";
	# 	toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
	# in 
	# {
	# 	enable = true;
	# 	extraConfig = toLua ''
	# 		vim.g.mapleader = " "
	#
	# 		vim.keymap.set("n", "<leader>pv", "<cmd>Explore<CR>")
	#
	# 		vim.keymap.set("n", "<leader>vca", function()
	# 				vim.lsp.buf.code_action()
	# 		end)
	#
	# 		vim.keymap.set("n", "<leader>vrn", function()
	# 				vim.lsp.buf.rename()
	# 		end)
	#
	#
	# 		vim.diagnostic.config({ virtual_text = true })
	# 		vim.o.tabstop = 4
	# 		vim.o.shiftwidth = 4
	# 		vim.o.guicursor = ""
	# 		vim.o.number = true
	# 		vim.o.relativenumber = true
	#
	# 		vim.api.nvim_create_autocmd("FileType", {
	# 			pattern = {"go"},
	# 			callback = function(ev)
	# 				vim.treesitter.start()
	# 			end
	# 		})
	#
	# 		require("caelus.init").colorscheme()
	# 	'';
	# 	plugins = with pkgs.vimPlugins; [
	# 	{
	# 		plugin = gruvbox-nvim;
	# 		# config = "colorscheme gruvbox";
	# 	}
	#
	# 	{
	# 		plugin = tokyonight-nvim;
	# 		# config = "colorscheme tokyonight";
	# 	}
	#
	# 	{
	# 		plugin = nvim-lspconfig;
	# 		config = toLua ''
	# 			vim.lsp.enable("lua_ls")
	# 			vim.lsp.enable("gopls")
	# 			vim.lsp.enable("rust_analyzer")
	# 			vim.lsp.enable("hls")
	# 			vim.lsp.config["qmlls"] = {
	# 				cmd = { "qmlls6" },
	# 				filetypes = { "qml" },
	# 				root_markers = { ".git" },
	# 			}
	# 			vim.lsp.enable("qmlls")
	# 			vim.lsp.enable("clangd")
	# 			vim.lsp.enable("ty")
	# 			vim.lsp.enable("pyright")
	# 			vim.lsp.enable("superhtml")
	# 			vim.lsp.enable("harper_ls")
	# 			vim.lsp.enable("astro")
	# 			vim.lsp.enable("tailwindcss")
	# 			vim.lsp.enable("ols")
	# 			vim.lsp.enable("nil_ls")
	# 			vim.lsp.enable("zls")
	# 		'';
	# 	}
	#
	# 	{
	# 		plugin = blink-cmp;
	# 		config = toLua ''
	# 		   require('blink.cmp').setup({
	# 			   keymap = { preset = 'enter' },
	#
	# 			   appearance = {
	# 				   nerd_font_variant = 'mono'
	# 			   },
	#
	# 			   completion = { documentation = { auto_show = true } },
	#
	# 			   sources = {
	# 				   default = { 'lsp', 'path', 'snippets', 'buffer' },
	# 			   },
	# 			   opts_extend = { "sources.default" }
	# 		   })
	# 		   '';
	# 	}
	#
	# 	{
	# 		plugin = telescope-nvim;
	# 		config = toLua ''
	# 			vim.g.mapleader = " "
	# 			vim.keymap.set("n", "<leader>pf", "<cmd>Telescope find_files<CR>")
	# 		'';
	# 	}
	#
	# 	{
	# 		plugin = everforest;
	# 		config = ''
	# 		let g:everforest_colors_override = {'bg0': ["", '234']}
	# 		'';
	# 	}
	#
	# 	{
	# 		plugin = trouble-nvim;
	# 		config = toLua ''
	# 			vim.keymap.set("n", "<leader>et", function()
	# 				require("trouble").toggle("diagnostics")
	# 			end)
	# 		'';
	# 	}
	#
	# 	{
	# 		plugin = render-markdown-nvim;
	# 	}
	#
	# 	{
	# 		plugin = rose-pine;
	# 		# config = ''
	# 		# 	colorscheme rose-pine
	# 		# '';
	# 	}
	#
	# 	{
	# 		plugin = nightfox-nvim;
	# 		# config = ''
	# 		# 	colorscheme terafox
	# 		# '';
	# 	}
	#
	# 	{
	# 		plugin = emmet-vim;
	# 	}
	#
	# 	{
	# 		plugin = nvim-ts-autotag;
	# 	}
	#
	# 	{
	# 		plugin = nvim-autopairs;
	# 		config = toLua ''
	# 			require("nvim-autopairs").setup({})
	# 		'';
	# 	}
	#
	# 	{
	# 		plugin = solarized-osaka-nvim;
	# 		# config = ''
	# 		# 	colorscheme solarized-osaka
	# 		# '';
	# 	}
	#
	# 	{
	# 		plugin = catppuccin-nvim;
	# 		config = ''
	# 			colorscheme catppuccin-mocha
	# 		'';
	# 	}
	#
	# 	{
	# 		plugin = lualine-nvim;
	# 		config = toLua ''
	# 			require('lualine').setup()
	# 		'';
	# 	}
	#
	# 	(nvim-treesitter.withPlugins (p: [
	# 		  p.go
	# 		  p.rust
	# 		  p.astro
	# 		  p.gleam
	# 		  p.nix
	# 		  p.zig
	# 	]))
	#
	# 	];
	# };

	home.file = {
	  ".config/niri".source = ./config/niri;
	  ".config/hypr".source = ./config/hypr;
	  ".config/nvim".source = ./config/nvim;
	  # ".config/nvim".force = true;
	  ".config/nvim".recursive = true;
	  ".config/sway".source = ./config/sway;
	};

	home.sessionVariables = {
		EDITOR = "nvim";
	};

	programs.home-manager.enable = true;
}
