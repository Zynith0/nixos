return {
	"neovim/nvim-lspconfig",
	config = function()
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
		vim.lsp.enable("zls")

		vim.diagnostic.config({
			update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
