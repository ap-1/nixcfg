local lint = require("lint")

lint.linters_by_ft = {
	markdown = { "markdownlint-cli2" },
	nix = { "statix", "deadnix" },
	yaml = { "yamllint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "FileType" }, {
	callback = function(ev)
		if vim.bo[ev.buf].buftype ~= "" then
			return
		end
		lint.try_lint()
		if vim.fs.root(ev.buf, ".editorconfig") then
			lint.try_lint("editorconfig-checker")
		end
	end,
})
