Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("lightblue"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid))
			:fg("lightblue"),
		" ",
	})
end, 500, Status.RIGHT)

-- NOTE: override the default behavior of the `mtime` function
-- https://github.com/sxyazi/yazi/blob/v25.3.2/yazi-plugin/preset/components/linemode.lua#L46
function Linemode:mtime()
	local mtime = math.floor(self._file.cha.mtime or 0)
	if mtime == 0 then
		mtime = ""
	else
		mtime = os.date("%Y-%m-%d %H:%M", mtime)
	end

	return mtime
end
