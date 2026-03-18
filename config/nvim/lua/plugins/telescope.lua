return {
	"nvim-telescope/telescope.nvim",
	config = function()
		vim.keymap.set("n", "<leader>pf", "<cmd>Telescope find_files<CR>")
	end,
}
