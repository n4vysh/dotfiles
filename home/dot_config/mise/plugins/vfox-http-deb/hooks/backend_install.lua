local function shell_quote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function render(template, version)
	return template:gsub("{{%s*version%s*}}", version)
end

local function platform_options(options)
	if RUNTIME.osType:lower() ~= "linux" then
		error("http-deb only supports Linux")
	end

	local arches = {
		amd64 = "x64",
		x86_64 = "x64",
		arm64 = "arm64",
		aarch64 = "arm64",
	}
	local arch = arches[RUNTIME.archType:lower()]
	if arch == nil then
		error("unsupported Linux architecture: " .. RUNTIME.archType)
	end

	local key = "linux-" .. arch
	local selected = options.platforms and options.platforms[key]
	if selected == nil then
		error("http-deb requires options for platform: " .. key)
	end
	return selected
end

local function verify_checksum(path, checksum)
	local algorithm, expected = checksum:match("^([%w%d]+):([%da-fA-F]+)$")
	if algorithm ~= "sha512" then
		error("http-deb requires a sha512 checksum")
	end

	local output = require("cmd").exec("sha512sum " .. shell_quote(path))
	local actual = output:match("^([%da-fA-F]+)")
	if actual == nil or actual:lower() ~= expected:lower() then
		error("checksum mismatch for downloaded deb")
	end
end

local function validate_entries(archive)
	local output = require("cmd").exec("bsdtar -tf " .. shell_quote(archive))
	for entry in output:gmatch("[^\r\n]+") do
		if
			entry:match("^/")
			or entry:match("^%.%./")
			or entry:match("/%.%./")
		then
			error("unsafe archive entry: " .. entry)
		end
	end
end

---@param ctx BackendInstallCtx
---@return BackendInstallResult
function PLUGIN:BackendInstall(ctx)
	local options = platform_options(ctx.options)
	local url_template = options.url
	if url_template == nil or url_template == "" then
		error("http-deb requires a platform 'url' option")
	end
	if options.checksum == nil or options.checksum == "" then
		error("http-deb requires a platform 'checksum' option")
	end

	local file = require("file")
	local deb = file.join_path(ctx.download_path, ctx.tool .. ".deb")
	local url = render(url_template, ctx.version)
	require("http").download_file({ url = url }, deb)

	verify_checksum(deb, options.checksum)

	local cmd = require("cmd")
	local outer = file.join_path(ctx.download_path, "deb")
	cmd.exec("mkdir -p " .. shell_quote(outer))
	validate_entries(deb)
	cmd.exec("bsdtar -xf " .. shell_quote(deb), { cwd = outer })

	local payloads = file.glob(file.join_path(outer, "data.tar*"))
	local payload
	local supported = {
		["data.tar"] = true,
		["data.tar.bz2"] = true,
		["data.tar.gz"] = true,
		["data.tar.xz"] = true,
		["data.tar.zst"] = true,
	}
	for _, candidate in ipairs(payloads) do
		local name = candidate:match("([^/\\]+)$")
		if supported[name] then
			if payload ~= nil then
				error("deb must contain exactly one supported data.tar archive")
			end
			payload = candidate
		end
	end
	if payload == nil then
		error("deb must contain exactly one data.tar archive")
	end

	validate_entries(payload)
	cmd.exec("mkdir -p " .. shell_quote(ctx.install_path))
	cmd.exec(
		"bsdtar -xf "
			.. shell_quote(payload)
			.. " -C "
			.. shell_quote(ctx.install_path)
	)

	return {}
end
