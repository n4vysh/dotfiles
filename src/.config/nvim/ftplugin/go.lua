do
	local augroup = "projectionist_go"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = augroup,
		pattern = { "ProjectionistDetect" },
		callback = function()
			vim.fn["projectionist#append"](vim.fn.getcwd(), {
				["*.go"] = {
					alternate = "{}_test.go",
				},
				["*_test.go"] = {
					alternate = "{}.go",
				},
			})
		end,
	})
end
