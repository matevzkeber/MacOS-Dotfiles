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

local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
	{ src = gh('catppuccin/nvim'), name = 'catppuccin' },
	gh('nvim-tree/nvim-web-devicons'),
	gh('nvim-tree/nvim-tree.lua'),
	gh('nvim-lualine/lualine.nvim'),
	gh('akinsho/bufferline.nvim'),
	gh('lewis6991/gitsigns.nvim'),
	gh('moll/vim-bbye'),
	gh('nvim-mini/mini.icons'),
	gh('nvim-mini/mini.pairs'),
	gh('nvim-mini/mini.snippets'),
	gh('nvim-mini/mini.completion'),
	gh('williamboman/mason.nvim'),
	gh('williamboman/mason-lspconfig.nvim'),
	gh('neovim/nvim-lspconfig'),
	{
		src = gh('nvim-treesitter/nvim-treesitter'),
		version = 'main',
		build = ':TSUpdate',
	},
})

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

require('mini.icons').setup()
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
require('mini.icons').tweak_lsp_kind()

-- LSPs, highlighting

local ts = require("nvim-treesitter");

local parsers = {
	"bash", "c", "cpp", "css", "diff", "csv",
	"dockerfile", "go", "html", "haskell",
	"gitignore", "javascript", "jsdoc", "json",
	"lua", "luadoc", "make", "markdown", "markdown_inline",
	"python", "regex", "rust", "svelte", "scss", "sql", "toml",
	"typescript", "vim", "xml", "yaml", "zig",
}
require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf, filetype = args.buf, args.match

		local language = vim.treesitter.language.get_lang(filetype)
		if not language then
			return
		end

		if not vim.treesitter.language.add(language) then
			return
		end

		vim.treesitter.start(buf, language)
	end,
})

local servers = { 'pyright', 'gopls', 'ts_ls', 'jsonls', 'lua_ls', 'clangd' } -- 'hls' instaled with ghcup
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
	virtual_text = false,
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
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>c', ':%y+<CR>')
