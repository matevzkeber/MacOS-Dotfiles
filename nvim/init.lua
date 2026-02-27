-- Vim settings
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.wrap = false
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.winborder = "rounded"

-- Plugins
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use { 'catppuccin/nvim', as = 'catppuccin' }                                               -- Colorscheme
	use 'nvim-tree/nvim-tree.lua'                                                              -- File tree
	use { 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons', opt = true } } -- Bottom bar
	use { 'akinsho/bufferline.nvim', tag = '*', requires = 'nvim-tree/nvim-web-devicons' }     -- Top bar
	use { 'lewis6991/gitsigns.nvim' }                                                          -- Git
	use 'nvim-tree/nvim-web-devicons'                                                          -- Nerd Font icons
	use 'moll/vim-bbye'                                                                        -- Buffer stuff
	use 'nvim-mini/mini-pairs.nvim'                                                            -- Pairs
	use 'nvim-mini/mini-snippets.nvim'                                                         -- Snippets
	use 'nvim-mini/mini-completion.nvim'                                                       -- Code completion
	use 'williamboman/mason.nvim'                                                              -- LSPs
	use 'williamboman/mason-lspconfig.nvim'
	use 'neovim/nvim-lspconfig'                                                                -- LSP configs
	use 'nvim-treesitter/nvim-treesitter'                                                      -- Syntax highlighting
end)

-- Configs
require('gitsigns').setup()
require('nvim-tree').setup { filters = { dotfiles = true } }

require('catppuccin').setup({
	flavour = 'frappe',
	transparent_background = true,
	default_integrations = true,
	integrations = { cmp = true, gitsigns = true, nvimtree = true, treesitter = true },
})
vim.cmd.colorscheme 'catppuccin'

require('lualine').setup {
	options = {
		theme = 'catppuccin',
		component_separators = '',
		section_separators = { left = '', right = '' }
	}
}

require('bufferline').setup {
	highlights = require('catppuccin.special.bufferline').get_theme(),
	options = {
		mode = 'buffers',
		close_command = 'Bdelete! %d',
		diagnostics = 'nvim_lsp',
		indicator = { style = 'icon' },
	}
}

require('mini.pairs').setup()
require('mini.snippets').setup()
require('mini.completion').setup {
	window = {
		info = { border = 'rounded' },
		signature = { border = 'rounded' },
	},
	lsp_completion = {
		source_func = 'omnifunc',
		auto_setup = true
	}
}

-- LSPs, highlighting
require('nvim-treesitter.configs').setup {
	auto_install = true,
	highlight = { enable = true }
}

local servers = { 'pyright', 'gopls', 'ts_ls', 'jsonls', 'lua_ls', 'clangd', 'lua_ls' } -- 'hls' instaled with ghcup
require('mason').setup()
require('mason').setup { ensure_installed = servers }

vim.lsp.enable(servers)
vim.lsp.config('hls', {
	cmd = { 'haskell-language-server-wrapper', '--lsp' },
	settings = { haskell = { formattingProvider = 'ormolu' } }
})
vim.lsp.enable('hls')

vim.diagnostic.config({
	signs = true,
	underline = true,
	severity_sort = true,
	update_in_insert = true,
})

-- Keybinds
vim.g.mapleader = ' '
vim.keymap.set('n', '<esc><esc>', ':noh<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>n', ':tabnew<CR>', { silent = true })            -- Open new buffer
vim.keymap.set('n', '<leader>k', ':Bdelete<CR>', { silent = true })           -- Close a buffer
vim.keymap.set('n', '<tab>', ':BufferLineCycleNext<CR>', { silent = true })   -- Cycling Bufferline
vim.keymap.set('n', '<S-tab>', ':BufferLineCyclePrev<CR>', { silent = true }) -- Reverse cycling Bufferline
vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format)
