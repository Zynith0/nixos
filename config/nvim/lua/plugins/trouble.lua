return {
	"folke/trouble.nvim",
	config = function()
		vim.keymap.set("n", "<leader>et", function()
			require("trouble").toggle("diagnostics")
		end)
	end,
}
