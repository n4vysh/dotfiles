vim.g.openbrowser_browser_commands = {
	{
		name = os.getenv("BROWSER"),
		args = {
			"{browser}",
			"{uri}",
		},
	},
}
