---@param ctx BackendExecEnvCtx
---@return BackendExecEnvResult
function PLUGIN:BackendExecEnv(ctx)
	if RUNTIME.osType:lower() ~= "linux" then
		error("http-deb only supports Linux")
	end
	local bin_path = ctx.options.bin_path
	if bin_path == nil or bin_path == "" then
		error("http-deb requires the 'bin_path' option")
	end

	return {
		env_vars = {
			{
				key = "PATH",
				value = require("file").join_path(ctx.install_path, bin_path),
			},
		},
	}
end
