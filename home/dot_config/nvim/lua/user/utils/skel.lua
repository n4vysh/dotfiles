local function load()
	local dir = os.getenv("XDG_CONFIG_HOME") .. "/nvim/skel/"
	local path = dir .. "default." .. vim.fn.expand("%"):match("[^.]+$")

	if vim.fn.filereadable(path) == 1 then
		vim.fn.execute("0r " .. path .. " | $delete _")
	end
end

return {
	load = load,
}
