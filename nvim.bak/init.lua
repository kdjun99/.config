-- 기본 설정
vim.g.mapleader = ',' -- <leader>를 Space로 설정
vim.opt.number = true          -- 라인 번호 표시
vim.opt.relativenumber = true  -- 상대 라인 번호 표시
vim.opt.tabstop = 2            -- 탭 크기 설정
vim.opt.shiftwidth = 2         -- 들여쓰기 크기
vim.opt.expandtab = true       -- 스페이스로 탭 변환
vim.opt.smartindent = true     -- 스마트 들여쓰기
vim.opt.wrap = false           -- 텍스트 줄 바꿈 비활성화
vim.opt.clipboard = "unnamedplus" -- 시스템 클립보드와 통합
vim.opt.updatetime = 300       -- 진단 메시지 업데이트 속도
vim.opt.cursorline = true      -- 커서 라인 강조
vim.opt.signcolumn = "yes"     -- Git 및 진단 표시를 위한 사이드 컬럼

-- packer.nvim 초기화
vim.cmd([[packadd packer.nvim]])

require('packer').startup(function(use)
  -- Packer 자체 관리
  use 'wbthomason/packer.nvim'

  -- UI 개선
  use {
    'nvim-lualine/lualine.nvim', -- 상태라인
    requires = { 'nvim-tree/nvim-web-devicons' } -- 아이콘 지원
  }
  use {
    'nvim-tree/nvim-tree.lua', -- 파일 탐색기
    requires = { 'nvim-tree/nvim-web-devicons' }
  }

  -- 검색 및 탐색
  use {
    'nvim-telescope/telescope.nvim', -- 파일 검색
    requires = { 'nvim-lua/plenary.nvim' }
  }

  -- Git 통합
  use 'lewis6991/gitsigns.nvim' -- Git 변경 사항 표시

  -- LSP (Language Server Protocol)
  use 'neovim/nvim-lspconfig' -- LSP 클라이언트
  use 'hrsh7th/nvim-cmp' -- 자동 완성 엔진
  use 'hrsh7th/cmp-nvim-lsp' -- LSP 소스 통합
  use 'hrsh7th/cmp-buffer' -- 버퍼 내용 자동 완성
  use 'hrsh7th/cmp-path' -- 파일 경로 자동 완성
  use 'L3MON4D3/LuaSnip' -- 스니펫 플러그인
  use 'saadparwaiz1/cmp_luasnip' -- LuaSnip과 통합

  -- 코드 포매팅 및 린팅
  use 'jose-elias-alvarez/null-ls.nvim' -- Prettier, ESLint 통합

  -- 디버깅
  use 'mfussenegger/nvim-dap' -- 디버깅 프로토콜 클라이언트
end)

-- 플러그인 로드 후 설정
-- lualine 설정
require('lualine').setup({
  options = {
    theme = 'ayu_light', -- 사용할 테마 설정
    section_separators = '', -- 섹션 구분 기호 제거
    component_separators = '|', -- 컴포넌트 구분 기호 설정
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
})

-- nvim-tree 설정
require('nvim-tree').setup()

-- telescope 설정
require('telescope').setup()

-- gitsigns 설정
require('gitsigns').setup()

-- LSP 설정
local lspconfig = require('lspconfig')

-- TypeScript LSP 설정
lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    -- 기본 키맵
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, bufopts)
  end
})


-- 자동 완성 설정
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'luasnip' },
  },
})

local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier, -- Prettier 포매팅
    null_ls.builtins.diagnostics.eslint, -- ESLint 린팅
    null_ls.builtins.code_actions.eslint, -- ESLint 코드 액션
  },
})

-- 일반 모드 키맵
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>') -- NvimTree 열기/닫기
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>') -- 파일 검색
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>') -- 텍스트 검색
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>') -- 버퍼 검색
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>') -- 도움말 검색
