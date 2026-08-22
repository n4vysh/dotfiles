local function select_field(values, field)
	local selected = {}
	for _, value in ipairs(values) do
		if type(value) ~= "table" or value[field] == nil then
			error("version_json_path field not found: " .. field)
		end
		table.insert(selected, value[field])
	end
	return selected
end

local function expand_arrays(values)
	local expanded = {}
	for _, value in ipairs(values) do
		if type(value) ~= "table" then
			error("version_json_path expected an array")
		end
		for _, item in ipairs(value) do
			table.insert(expanded, item)
		end
	end
	return expanded
end

local function filter_arrays(values, field, expected)
	local filtered = {}
	for _, value in ipairs(values) do
		if type(value) ~= "table" then
			error("version_json_path filter expected an array")
		end
		for _, item in ipairs(value) do
			if type(item) == "table" and tostring(item[field]) == expected then
				table.insert(filtered, item)
			end
		end
	end
	return filtered
end

local function evaluate_json_path(data, path)
	if path == "." then
		return { data }
	end
	if path:sub(1, 1) ~= "." then
		error("version_json_path must start with '.'")
	end

	local values = { data }
	local cursor = 2
	while cursor <= #path do
		local current = path:sub(cursor, cursor)
		if current == "." then
			cursor = cursor + 1
		elseif path:sub(cursor, cursor + 1) == "[]" then
			values = expand_arrays(values)
			cursor = cursor + 2
		elseif path:sub(cursor, cursor + 1) == "[?" then
			local close = path:find("]", cursor, true)
			if close == nil then
				error("unterminated version_json_path filter")
			end
			local expression = path:sub(cursor + 2, close - 1)
			local field, expected = expression:match("^([%w_%-]+)=([^=]+)$")
			if field == nil then
				error("invalid version_json_path filter: " .. expression)
			end
			values = filter_arrays(values, field, expected)
			cursor = close + 1
		else
			local field = path:match("^([%w_%-]+)", cursor)
			if field == nil then
				error("invalid version_json_path near: " .. path:sub(cursor))
			end
			values = select_field(values, field)
			cursor = cursor + #field
		end
	end

	return values
end

local function collect_versions(values)
	local versions = {}
	local function collect(value)
		if type(value) == "table" then
			for _, item in ipairs(value) do
				collect(item)
			end
		elseif type(value) == "string" or type(value) == "number" then
			table.insert(versions, (tostring(value):gsub("^v", "")))
		else
			error("version_json_path must resolve to strings or numbers")
		end
	end

	for _, value in ipairs(values) do
		collect(value)
	end
	if #versions == 0 then
		error("version_json_path returned no versions")
	end
	return versions
end

---@param ctx BackendListVersionsCtx
---@return BackendListVersionsResult
function PLUGIN:BackendListVersions(ctx)
	local url = ctx.options.version_list_url
	local path = ctx.options.version_json_path
	if url == nil or url == "" then
		error("http-deb requires the 'version_list_url' option")
	end
	if path == nil or path == "" then
		error("http-deb requires the 'version_json_path' option")
	end

	local response = require("http").get({ url = url })
	if response.status_code ~= 200 then
		error("version list returned HTTP " .. response.status_code)
	end

	local data = require("json").decode(response.body)
	local versions = collect_versions(evaluate_json_path(data, path))
	return { versions = require("semver").sort(versions) }
end
