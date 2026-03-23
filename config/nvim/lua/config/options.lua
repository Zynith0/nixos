vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", "<cmd>Explore<CR>")

vim.keymap.set("n", "<leader>vca", function()
	vim.lsp.buf.code_action()
end)

vim.keymap.set("n", "<leader>vrn", function()
	vim.lsp.buf.rename()
end)


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

vim.api.nvim_create_autocmd("FileType", {
	pattern = {"go"},
	callback = function(ev)
		vim.treesitter.start()
	end
})

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
