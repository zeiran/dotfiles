if vim.g.neovide then
	vim.o.guifont = "Fira Code:h11"
	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 5
	vim.g.neovide_padding_left = 5
end

vim.cmd("colorscheme catppuccin")
vim.o.shiftwidth=4
vim.o.tabstop=4

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
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<F2>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<F3>', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<F1>', builtin.buffers, { desc = 'Telescope buffers' })

---- Mason

-- in Mason, install clang-format
vim.pack.add({
	'https://github.com/mason-org/mason.nvim'
})
require("mason").setup()

---- Conform (formatting)

vim.pack.add({
	'https://github.com/stevearc/conform.nvim'
})
require("conform").setup({
  formatters_by_ft = {
    cpp = { "clang-format" }
  },
  format_on_save = {
    timeout_ms = 500,
  },
})

