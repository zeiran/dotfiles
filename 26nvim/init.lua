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

-- Leap

vim.pack.add { 'https://codeberg.org/andyg/leap.nvim' }
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
vim.keymap.set({ 'x', 'o' },      'x', '<Plug>(leap-next-to)')
vim.keymap.set({ 'n' },           'S', '<Plug>(leap-from-window)')
