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
