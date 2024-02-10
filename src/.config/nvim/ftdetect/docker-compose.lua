-- NOTE: Set filetype for compose-language-service
do
	local augroup = "docker-compose"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		pattern = {
			"compose.yaml",
			"compose.yml",
			"docker-compose.yaml",
			"docker-compose.yml",
		},
		callback = function()
			vim.opt_local.filetype = "yaml.docker-compose"
		end,
	})
end
