local M = {}

-- macOS의 현재 테마를 확인하는 함수
M.get_macos_theme = function()
	local handle = io.popen("defaults read -g AppleInterfaceStyle")
	if handle == nil then
		return "light" -- 기본값을 light로 설정
	end
	local result = handle:read("*a")
	handle:close()
	if result == nil or result:gsub("%s+", "") == "" then
		return "light"
	else
		return "dark"
	end
end

return M
