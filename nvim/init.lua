---- plugins ----

local Plug = vim.fn['plug#']
vim.call('plug#begin')
    -- graphics
    Plug('nvim-tree/nvim-web-devicons')
    Plug('kvrohit/substrata.nvim')
    Plug('comfysage/evergarden')
    --filesystem
    Plug('stevearc/oil.nvim')
    --coding
    Plug('preservim/nerdcommenter')
    -- LSP
    Plug('williamboman/mason.nvim')
    Plug('williamboman/mason-lspconfig.nvim')
    Plug('neovim/nvim-lspconfig')
    Plug('saghen/blink.cmp', { tag = 'v0.*' })
vim.call('plug#end')

---- plugins.lsp ---

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls" }
})

local blink = require('blink.cmp')
blink.setup({})

vim.uv.os_setenv('VIMRUNTIME', vim.env.VIMRUNTIME) -- used in `.luarc.json` to find vim runtime definitions, assuming that LSP server starts as child process of Vim

require('lspconfig').lua_ls.setup({
    capabilities = blink.get_lsp_capabilities({}, true),
    settings = {
        Lua = { --defaults for vim-related scripts, other projects should use `.luarc.json` file
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                ignoreSubmodules = false,
                library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" }
            }
        }
    }
})

---- plugins.filesystem ----

require('oil').setup({
    columns = { "icon" },
    delete_to_trash = true
})

---- graphics ----

if vim.g.neovide then
    vim.g.neovide_padding_top = 10
    vim.g.neovide_padding_left = 20
    vim.g.neovide_padding_right = 20
    vim.g.neovide_fullscreen = true
end

vim.cmd('colorscheme evergarden')
vim.o.guifont = 'Agave Nerd Font:h14'
vim.o.relativenumber = true
vim.o.number = true
vim.o.hlsearch = false

---- behaviour ----

vim.o.tabstop = 8
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.formatoptions = 'jql' -- do not autoinsert comment leader at newline

---- mappings ----

vim.keymap.set('n', '<F1>', require("oil").open_float) -- open dir with current file
vim.cmd('map <F8> :wall<CR>:source %<CR>')             -- source current file to Vim
