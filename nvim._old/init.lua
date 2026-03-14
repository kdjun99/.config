-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- require("catppuccin").load("macchiato")
-- require("kanagawa").load("dragon")
-- require("plugins.dracula")
-- vim.cmd("colorscheme dracula_pro")

-- ────────────────────────────────────────────────────────────────────────
-- 1. OS 모드 감지 함수
--    • macOS  : `defaults read -g AppleInterfaceStyle` → "Dark" 이면 다크
--    • GNOME  : `gsettings get org.gnome.desktop.interface color-scheme`
--               → "prefer-dark"·"default-dark" 포함 시 다크
-- ────────────────────────────────────────────────────────────────────────
local function is_dark_mode()
  -- macOS
  if vim.fn.has("macunix") == 1 then
    local ok, out = pcall(vim.fn.system, { "defaults", "read", "-g", "AppleInterfaceStyle" })
    return ok and out:match("Dark")
  end

  -- GNOME 42+
  if vim.fn.executable("gsettings") == 1 then
    local ok, out = pcall(vim.fn.system, { "gsettings", "get", "org.gnome.desktop.interface", "color-scheme" })
    return ok and out:match("[dD]ark")
  end

  -- 기타 플랫폼: 기본값 = Light
  return false
end

-- 2. 테마 적용 함수 ------------------------------------------------------
local function apply_theme()
  if is_dark_mode() then
    -- 다크 모드
    require("kanagawa")
    --require("plugins.dracula") -- lazy.nvim spec 로더
    --vim.cmd.colorscheme("github_dark_default") -- 다크 테마
    --vim.cmd.colorscheme("everforest")
    vim.cmd.colorscheme("kanagawa-dragon")
  else
    -- 라이트 모드
    --require("kanagawa")
    --require("plugins.dracula") -- ← 플러그인 spec에 등록돼 있어야 함
    --vim.cmd.colorscheme("github_light_default")
    --vim.cmd.colorscheme("kanagawa-dragon")
    vim.cmd.colorscheme("everforest")
  end
end

apply_theme() -- Neovim 시작 시 한 번 실행

-- 3. 포커스가 돌아올 때 OS 테마가 바뀌었는지 재확인 ----------------------
--vim.api.nvim_create_autocmd("FocusGained", {
--  callback = apply_theme,
--})
