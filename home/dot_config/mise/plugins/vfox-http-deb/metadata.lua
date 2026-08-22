---@type Plugin
PLUGIN = {
	name = "http-deb",
	version = "0.1.0",
	description = "Install Debian packages from HTTP URLs",
	author = "n4vysh",
	license = "MIT",
	minRuntimeVersion = "0.3.0",
	systemDependencies = {
		{
			bin = "bsdtar",
			packages = {
				pacman = "libarchive",
				apt = "libarchive-tools",
			},
		},
		{
			bin = "mkdir",
			packages = {
				pacman = "coreutils",
				apt = "coreutils",
			},
		},
		{
			bin = "sha512sum",
			packages = {
				pacman = "coreutils",
				apt = "coreutils",
			},
		},
	},
}
