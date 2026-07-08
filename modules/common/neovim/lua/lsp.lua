require("lazydev").setup()

vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
		},
	},
})

vim.lsp.enable({
	"lua_ls",
	"nixd",
	"bashls",
	"taplo",
	"rust_analyzer",
	"ruff",
	"ty",
	"oxlint",
	"tofu_ls",
	"marksman",
	"yamlls",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
	end,
})

vim.keymap.set("n", "grf", vim.lsp.buf.format, { desc = "format (lsp)" })
