local function disable()
	if
		os.getenv("WAYLAND_DISPLAY") ~= nil
		and vim.fn.executable("fcitx5-remote") == 1
		and os.getenv("WSL_DISTRO_NAME") == nil
	then
		if io.popen("pgrep fcitx") ~= nil then
			local output = io.popen("fcitx5-remote")

			if output ~= nil and output:read() == "2" then
				os.execute("fcitx5-remote -c")
			end
		end
	end
end

return {
	disable = disable,
}
