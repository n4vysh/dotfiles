do
	local auname = "projectionist_go"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = auname,
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
