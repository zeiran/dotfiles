---- plugins ----

Plug = vim.fn['plug#']
vim.call('plug#begin')
    -- graphics
    Plug('nvim-tree/nvim-web-devicons')
    Plug('rktjmp/lush.nvim')
    Plug('kvrohit/substrata.nvim')
    Plug('comfysage/evergarden')
    Plug('zenbones-theme/zenbones.nvim')
    --interface
    Plug('romgrk/barbar.nvim')
    Plug('nvim-lualine/lualine.nvim')
    --filesystem
    Plug('stevearc/oil.nvim')
    --coding
    Plug('preservim/nerdcommenter')
    --building
    --Plug('nvim-lua/plenary.nvim')
    --Plug('Civitasv/cmake-tools.nvim')
    -- LSP
    Plug('williamboman/mason.nvim')
    Plug('williamboman/mason-lspconfig.nvim')
    Plug('neovim/nvim-lspconfig')
    Plug('saghen/blink.cmp', { tag = 'v0.*' })
    -- startup
    Plug('goolord/alpha-nvim')
    --dev
    Plug(vim.env['NVIM_PLUGIN_DEV']..'\\nvim-launchpad')
vim.call('plug#end')

package.loaded['launchpad'] = nil
require('launchpad').setup()

---- plugins.interface ----

vim.cmd([[
    nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
    nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>
    nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
    nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>
    nnoremap <silent>    <A-1> <Cmd>BufferGoto 1<CR>
    nnoremap <silent>    <A-2> <Cmd>BufferGoto 2<CR>
    nnoremap <silent>    <A-3> <Cmd>BufferGoto 3<CR>
    nnoremap <silent>    <A-4> <Cmd>BufferGoto 4<CR>
    nnoremap <silent>    <A-5> <Cmd>BufferGoto 5<CR>
    nnoremap <silent>    <A-6> <Cmd>BufferGoto 6<CR>
    nnoremap <silent>    <A-7> <Cmd>BufferGoto 7<CR>
    nnoremap <silent>    <A-8> <Cmd>BufferGoto 8<CR>
    nnoremap <silent>    <A-9> <Cmd>BufferGoto 9<CR>
    nnoremap <silent>    <A-0> <Cmd>BufferLast<CR>
    nnoremap <silent>    <A-p> <Cmd>BufferPin<CR>
    nnoremap <silent>    <A-c> <Cmd>BufferClose<CR>
    nnoremap <silent>    <A-s-c> <Cmd>BufferRestore<CR>
    nnoremap <silent> <A-/>    <Cmd>BufferPick<CR>
    nnoremap <silent> <A-s-/>    <Cmd>BufferPickDelete<CR>
]])

require('lualine').setup({
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diagnostics' },
        lualine_c = { {'filename', path=1} },
        lualine_x = { 'filetype' },
        lualine_y = { 'location', 'progress' },
        lualine_z = { 'getcwd', {'g:my_project', color={fg='black', gui='bold'}} }
    }
})

---- plugins.lsp ---

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls" }
})

local blink = package.loaded['blink.cmp']
if not blink then
    blink = require('blink.cmp')
    blink.setup({})
end

vim.uv.os_setenv('VIMRUNTIME', vim.env.VIMRUNTIME) -- used in `.luarc.json` to find vim runtime definitions, assuming that LSP server starts as child process of Vim

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({
    capabilities = blink.get_lsp_capabilities({}, true),
    settings = {
        Lua = { --defaults for vim-related scripts, other projects should use `.luarc.json` file
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                --ignoreSubmodules = false,
                --library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" }
                library = vim.list_extend({"${3rd}/luv/library"}, vim.api.nvim_get_runtime_file("", true))
            }
        }
    }
})
lspconfig.clangd.setup({
    capabilities = blink.get_lsp_capabilities({}, true),
    cmd = { 'clangd', '--completion-style=detailed', '--background-index' },
})

---- plugins.filesystem ----

require('oil').setup({
    columns = { "icon" },
    delete_to_trash = true,
    keymaps = {["<Esc>"] = "actions.close"}
})

---- graphics ----

if vim.g.neovide then
    vim.g.neovide_padding_top = 10
    vim.g.neovide_padding_left = 20
    vim.g.neovide_padding_right = 20
    vim.g.neovide_fullscreen = true
end

vim.cmd('colorscheme substrata')
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
vim.keymap.set('n', '<S-F1>', ":Alpha<CR>")

vim.cmd('map <F6> :lua vim.diagnostic.setqflist()<CR>')

vim.cmd('map <F8> :wall<CR>:source %<CR>')             -- source current file to Vim
vim.cmd('map <S-F8> :wall<CR>:!powershell -command "Start-Process neovide.exe %"<CR><CR>:qall<CR>')         -- restart with current file
vim.cmd('map <A-F8> "lyy:lua <C-r>l<CR>')

vim.cmd('imap <Ins> <Esc>')

local scheme_index = 0
vim.keymap.set('n', '<F12>', function ()
    local schemes = {'substrata', 'desert', 'neobones', 'evergarden'}
    scheme_index = (scheme_index + 1 > #schemes) and 1 or scheme_index + 1
    local scheme = schemes[scheme_index]
    vim.cmd.colorscheme(scheme)
    vim.notify('colorscheme '..scheme)
end)

--- globals ---

vim.g.my_project = '?'

--- greeter ---

require'greeter'.show()

