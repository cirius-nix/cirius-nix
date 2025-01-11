local ok, wezterm = pcall(require, "wezterm")
if not ok then
	return
end

local config = {
	automatically_reload_config = true,
}

return config
