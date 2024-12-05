---=== plugins ===---

Plug = vim.fn['plug#']
vim.call('plug#begin')
    -- graphics
    Plug('nvim-tree/nvim-web-devicons')
    Plug('rktjmp/lush.nvim')
    Plug('kvrohit/substrata.nvim')
    Plug('comfysage/evergarden')
    Plug('rafamadriz/neon')
    Plug('aktersnurra/no-clown-fiesta.nvim')
    Plug('sainnhe/gruvbox-material')
    Plug('neanias/everforest-nvim')
    --interface
    Plug('romgrk/barbar.nvim')
    Plug('nvim-lualine/lualine.nvim')
    --filesystem
    Plug('stevearc/oil.nvim')
    --coding
    Plug('preservim/nerdcommenter')
    -- LSP
    Plug('williamboman/mason.nvim')
    Plug('williamboman/mason-lspconfig.nvim')
    Plug('neovim/nvim-lspconfig')
    Plug('saghen/blink.cmp', { tag = 'v0.*' })
    -- startup
    Plug('goolord/alpha-nvim')
    --dev
    Plug(vim.env['NVIM_PLUGIN_DEV']..'\\nvim-launchpad')
    Plug(vim.env['NVIM_PLUGIN_DEV']..'\\nvim-windbg')
vim.call('plug#end')

package.loaded['launchpad'] = nil
require('launchpad').setup()

---=== plugins.interface ===---

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
local barbar = require'barbar'
barbar.setup()

local lualine = require('lualine')
local lualine_cfg = {
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diagnostics' },
        lualine_c = { {'filename', path=1} },
        lualine_x = { 'filetype' },
        lualine_y = { 'location', 'progress' },
        lualine_z = { 'getcwd', {'g:my_project', color={fg='black', gui='bold'}} }
    }
}
lualine.setup(lualine_cfg)

---=== plugins.lsp ===---

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
lspconfig.cmake.setup{}

---=== plugins.filesystem ===---

local function oil_copy_path_to_register()
    local oil = require('oil')
    local path = oil.get_current_dir()..oil.get_cursor_entry().name
    vim.fn.setreg(vim.v.register, path)
    vim.notify('Copied to "'..vim.v.register..': '..path)
end

require('oil').setup({
    columns = { "icon" },
    delete_to_trash = true,
    keymaps = {
        ["<Esc>"] = "actions.close",
        ["<C-c>"] = {oil_copy_path_to_register, desc='copy path to register'}
    }
})

---=== plugins.dev ===---

require'windbg'.setup({
    cdb_path = '$SYSTEMDRIVE\\Program Files (x86)\\Windows Kits\\10\\Debuggers\\x64\\cdb.exe',
    windbg_path = '$LOCALAPPDATA\\Microsoft\\WindowsApps\\WinDbgX.exe',
    devmode = true,
    windbg_log_file = vim.fn.tempname()..'.windbg_out.log',
    plugin_log_file = vim.fn.tempname()..'.windbg_plg.log',
})


---=== graphics ===---

if vim.g.neovide then
    vim.g.neovide_padding_top = 10
    vim.g.neovide_padding_left = 20
    vim.g.neovide_padding_right = 20
    vim.g.neovide_fullscreen = true
end

vim.o.guifont = 'Agave Nerd Font:h14'
vim.o.relativenumber = true
vim.o.number = true
vim.o.hlsearch = false

local colorschemes = require'colorschemes'
colorschemes.setup(lualine, lualine_cfg, barbar)

---=== behaviour ===---

vim.o.tabstop = 8
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.formatoptions = 'jql' -- do not autoinsert comment leader at newline

---=== mappings ===---

vim.cmd('imap <Ins> <Esc>')
vim.cmd('tmap <Esc> <C-\\><C-n>')

vim.keymap.set('n', '<F1>', require("oil").open_float) -- open dir with current file
vim.keymap.set('n', '<S-F1>', ":Alpha<CR>")

-- <F5> was set by nvim-launchpad
vim.cmd('map <F6> :lua vim.diagnostic.setqflist()<CR>')

vim.cmd('map <F8> :wall<CR>:source %<CR>')             -- source current file to Vim
vim.cmd('map <S-F8> :wall<CR>:!powershell -command "Start-Process neovide.exe %"<CR><CR>:qall<CR>')         -- restart with current file
vim.cmd('map <A-F8> "lyy:lua <C-r>l<CR>')
-- <C-F8> for project-specific re-soure

vim.keymap.set('n', '<F12>', colorschemes.switch)

---=== greeter ===---

if not vim.g.my_project then require'greeter'.show() end

---=== globals ===---

vim.g.my_project = '?'

Z = {}
Z.cache = require'cache'

