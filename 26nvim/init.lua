
local user = os.getenv('LOGNAME')
local kl = (user == 'alexeev_ev@avp.ru')
print('USER=' .. user .. ', KL=' .. tostring(kl))

if vim.g.neovide then
	vim.o.guifont = "Fira Code:h11"
	vim.g.neovide_padding_top = 5
	vim.g.neovide_padding_bottom = 5
	vim.g.neovide_padding_right = 10
	vim.g.neovide_padding_left = 10

	vim.g.neovide_fullscreen = true
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_cursor_vfx_particle_lifetime = 0.5
	vim.g.neovide_cursor_vfx_particle_highlight_lifetime = 0.2
end

vim.cmd("colorscheme catppuccin")
vim.o.shiftwidth=4
vim.o.tabstop=4
vim.o.hlsearch=false

---- Colorscheme

vim.pack.add { "https://github.com/neanias/everforest-nvim" }
require("everforest").setup({
	background = "hard"
})
vim.cmd([[colorscheme everforest]])

---- Dynamic font 

-- maps ctrl++, ctl+-, ctrl-shift-=
vim.pack.add({
	'https://github.com/tenxsoydev/size-matters.nvim'
})
require("size-matters").setup()

---- Leap

vim.pack.add { 'https://codeberg.org/andyg/leap.nvim' }
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
vim.keymap.set({ 'x', 'o' },      'x', '<Plug>(leap-next-to)')
vim.keymap.set({ 'n' },           'S', '<Plug>(leap-from-window)')

---- Lualine

vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim'
})
require('lualine').setup({
	sections = {
		lualine_x = {'getcwd'},
		lualine_y = {'filetype', 'encoding'},
		lualine_z = {'progress', 'location'}
	},
	options = {
		theme = "auto"
	}
})

---- Telescope

-- sudo apt install ripgrep
-- sudo apt install fd-find
-- TODO install telescope-fzf-native.nvim or telescope-fzy-native.nvim ?
vim.pack.add({
	'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
	'https://github.com/nvim-telescope/telescope.nvim'
})

require('telescope').setup{
	defaults = {
		layout_strategy = 'vertical',
		layout_config = { height = 0.99 },
	}
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<F2>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<F3>', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<F1>', function() builtin.buffers({sort_mru=true, ignore_current_buffer=true}) end, { desc = 'Telescope buffers' })

vim.pack.add({
	'https://github.com/natecraddock/telescope-zf-native.nvim'
})
require("telescope").load_extension("zf-native")

vim.pack.add({
	'https://github.com/nvim-telescope/telescope-ui-select.nvim'
})
require("telescope").load_extension("ui-select")

---- Mason

-- in Mason, install clang-format, clangd
vim.pack.add({
	'https://github.com/mason-org/mason.nvim'
})
require("mason").setup()

---- Conform (formatting)

vim.pack.add({
	'https://github.com/stevearc/conform.nvim'
})
local formatter = 'clang-format'
if kl then formatter = 'clang-format-18' end
require("conform").setup({
  formatters_by_ft = {
    cpp = { "clang-format" }
  },
  formatters = {
  	["clang-format"] = {
	  command = formatter	
	}
  },
  format_on_save = {
    timeout_ms = 500,
  },
})

--- LSP configs

-- symlink your compile_commands.json to project root

vim.pack.add({
	'https://github.com/neovim/nvim-lspconfig'
})
vim.lsp.enable('clangd')

vim.keymap.set('n', '<F5>', vim.diagnostic.open_float, { desc = 'LSP diagnostics open float' })
vim.keymap.set('n', '<S-F5>', vim.diagnostic.setqflist, { desc = 'LSP diagnostics to quickfix' })

vim.keymap.set('n', '<S-F3>', function() 
	builtin.lsp_dynamic_workspace_symbols({symbols = {'struct', 'class'}})
end, { desc = 'Telescope LSP types' })


--- Blink completion

vim.pack.add({ 
	'https://github.com/saghen/blink.lib', 
	{src='https://github.com/saghen/blink.cmp', version="v1.10.2"} 
})
local cmp = require('blink.cmp')
--cmp.build():pwait() -- it's for v2
cmp.setup()

--- Oil

vim.pack.add({
    'https://github.com/stevearc/oil.nvim',
})
local oil = require("oil")
oil.setup()
vim.keymap.set('n', '<F4>', oil.open, { desc = 'Open file dir' })

---- CMake

vim.pack.add({
	'https://github.com/Civitasv/cmake-tools.nvim'
})
require("cmake-tools").setup({
	cmake_regenerate_on_save=false,
	cmake_executor = {
		name = "quickfix",
		opts = {size=30}, 
	}
})

vim.keymap.set('n', '<F7>', ":CMakeBuild<CR>", { desc = 'CMake build' })
vim.keymap.set('n', '<C-F7>', ":CMakeSelectBuildTarget<CR>", { desc = 'Cmake select build target' })
vim.keymap.set('n', '<S-F7>', ":CMakeQuickBuild<CR>", { desc = 'Cmake quick build' })

vim.keymap.set('n', '<F8>', ":CMakeRun<CR>", { desc = 'CMake run' })
vim.keymap.set('n', '<C-F8>', ":CMakeSelectLaunchTarget<CR>", { desc = 'Cmake select launch target' })
vim.keymap.set('n', '<S-F8>', ":CMakeQuickRun<CR>", { desc = 'Cmake quick run' })














