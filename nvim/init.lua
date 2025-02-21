---=== plugins ===---

Plug = vim.fn["plug#"]
vim.call("plug#begin")
-- graphics
Plug("nvim-tree/nvim-web-devicons")
Plug("rktjmp/lush.nvim")
Plug("kvrohit/substrata.nvim")
Plug("comfysage/evergarden")
Plug("rafamadriz/neon")
Plug("aktersnurra/no-clown-fiesta.nvim")
Plug("sainnhe/gruvbox-material")
Plug("neanias/everforest-nvim")
--interface
Plug("romgrk/barbar.nvim")
Plug("nvim-lualine/lualine.nvim")
--filesystem
Plug("stevearc/oil.nvim")
--searching
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim", { tag = "0.1.8" }) -- install native sorters for better performance
--coding
Plug("preservim/nerdcommenter")
Plug("ggandor/leap.nvim")
--debug
Plug("mfussenegger/nvim-dap")
Plug("nvim-neotest/nvim-nio")
Plug("rcarriga/nvim-dap-ui")
-- LSP
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("neovim/nvim-lspconfig")
Plug("saghen/blink.cmp", { tag = "v0.*" })
Plug("artemave/workspace-diagnostics.nvim")
Plug("folke/lazydev.nvim")
--- formatting
Plug("stevearc/conform.nvim")
-- startup
Plug("goolord/alpha-nvim")
--dev
Plug(vim.env["NVIM_PLUGIN_DEV"] .. "\\nvim-launchpad")
--    Plug(vim.env['NVIM_PLUGIN_DEV']..'\\nvim-windbg')
vim.call("plug#end")

local function notify_on_error(what, func)
	local succeeded, result = pcall(func)
	if not succeeded then
		vim.notify(what .. " failed: " .. result, vim.log.levels.WARN)
	end
	return result
end

notify_on_error("launchpad", function()
	require("launchpad").setup()
end)

---=== plugins.interface ===---

local barbar = nil
notify_on_error("barbar", function()
	barbar = require("barbar")
	barbar.setup({
		icons = { button = false, buffer_index = true },
	})
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
	return barbar
end)

local lualine = nil
local lualine_cfg = nil
notify_on_error("lualine", function()
	lualine = require("lualine")
	lualine_cfg = {
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "diagnostics" },
			lualine_c = { { "filename", path = 1 } },
			lualine_x = { "filetype" },
			lualine_y = { "location", "progress" },
			lualine_z = { "getcwd", { "g:my_project", color = { fg = "black", gui = "bold" } } },
		},
	}
	lualine.setup(lualine_cfg)
end)

---=== plugins.lsp ===---

notify_on_error("LSP", function()
	vim.keymap.set(
		"n",
		"<Leader>lr",
		":lua vim.lsp.buf.references()<CR>",
		{ desc = "[lsp] list references in quickfix" }
	)
	vim.keymap.set(
		"n",
		"<Leader>li",
		require("telescope.builtin").lsp_implementations,
		{ desc = "[lsp] go to implementation by Telescope" }
	)
	vim.keymap.set("n", "<Leader>lm", function()
		require("telescope.builtin").lsp_document_symbols({ symbols = { "method", "function" } })
	end, { desc = "[lsp] go to implementation by Telescope" })
	vim.keymap.set("n", "<Leader>lc", function()
		require("telescope.builtin").lsp_workspace_symbols({
			path_display = { "tail" },
			symbols = { "class", "interface" },
		})
	end, { desc = "[lsp] go to implementation by Telescope" })
	vim.keymap.set("n", "<Leader>lw", function()
		for _, client in ipairs(vim.lsp.get_clients()) do
			require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
		end
	end, { desc = "[lsp] show diagnostics for whole project for current filetype" })

	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = { "lua_ls" },
	})

	require("lazydev").setup({
		library = {
			-- See the configuration section for more details
			-- Load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	})

	local blink = package.loaded["blink.cmp"]
	if not blink then
		blink = require("blink.cmp")
		blink.setup({
			signature = { enabled = true },
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},
		})
	end

	--vim.uv.os_setenv('VIMRUNTIME', vim.env.VIMRUNTIME) -- used in `.luarc.json` to find vim runtime definitions, assuming that LSP server starts as child process of Vim

	local lspconfig = require("lspconfig")
	lspconfig.lua_ls.setup({
		capabilities = blink.get_lsp_capabilities({}, true),
		--settings = {
		--Lua = { --defaults for vim-related scripts, other projects should use `.luarc.json` file
		--runtime = { version = 'LuaJIT' },
		--workspace = {
		--checkThirdParty = false,
		----ignoreSubmodules = false,
		----library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" }
		--library = vim.list_extend({ "${3rd}/luv/library" }, vim.api.nvim_get_runtime_file("", true))
		--}
		--}
		--}
	})
	lspconfig.clangd.setup({
		capabilities = blink.get_lsp_capabilities({}, true),
		cmd = { "clangd", "--completion-style=detailed", "--background-index" },
	})
	lspconfig.cmake.setup({
		capabilities = blink.get_lsp_capabilities({}, true),
	})
	lspconfig.ts_ls.setup({})
	lspconfig.cssls.setup({
		capabilities = blink.get_lsp_capabilities({}, true),
	})
	require("workspace-diagnostics").setup()
end)

---=== plugins.filesystem ===---

-- use ::ConformInfo for status
local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		javascript = { "prettierd", "prettier", stop_after_first = true }, -- install `prettier` with Mason
		typescript = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		lua = { "stylua" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
	},
})
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local formatters = #require("conform").list_formatters_to_run()
		if formatters ~= 0 then
			vim.notify("Using `conform` for buffer " .. bufnr .. "...")
			vim.bo[bufnr].formatexpr = "v:lua.require'conform'.formatexpr()"
		end
	end,
})

---=== plugins.filesystem ===---

local oil = require("oil")

local function oil_copy_path_to_register()
	local path = oil.get_current_dir() .. oil.get_cursor_entry().name
	vim.fn.setreg(vim.v.register, path)
	vim.notify('Copied to "' .. vim.v.register .. ": " .. path)
end
local function oil_open_shortcuts()
	vim.cmd("silent wall")

	local cfg = tostring(vim.fn.stdpath("config"))
	local buffer = vim.fn.bufnr(vim.fs.joinpath(cfg, "drips.oil"), true)
	vim.cmd(buffer .. "b")
	vim.cmd("set nobl")
	local oil_goto = function()
		local line = vim.fn.getline(vim.fn.line("."))
		vim.cmd.edit(vim.fn.expandcmd(line))
	end
	vim.keymap.set("n", "<CR>", oil_goto, { buffer = true, desc = "[oil drips] Go to dir on current line" })
	vim.keymap.set("n", "<Esc>", vim.cmd.bdelete, { buffer = true, desc = "[oil drips] Close" })
end
local function oil_close_and_return_dir()
	local dir = oil.get_current_dir()
	require("oil.actions").close.callback()
	return dir
end

require("oil").setup({
	columns = { "icon" },
	delete_to_trash = true,
	keymaps = {
		["<Esc>"] = "actions.close",
		["<C-c>"] = { oil_copy_path_to_register, desc = "[my] copy path to register" },
		["<F1>"] = { oil_open_shortcuts, desc = "[my] open shortcuts buffer (drips.oil)" },
		["<F2>"] = {
			function()
				require("telescope.builtin").find_files({ cwd = oil_close_and_return_dir() })
			end,
			desc = "[my] telescope dir",
		},
		["<S-F2>"] = {
			function()
				require("telescope.builtin").live_grep({ cwd = oil_close_and_return_dir() })
			end,
			desc = "[my] telescope dir for contents",
		},
	},
})

---=== plugins.coding ===---
notify_on_error("leap", function()
	require("leap").create_default_mappings()
end)

---=== plugins.debug ===---
notify_on_error("DAP", function()
	require("debug_dap")
end)

---=== plugins.dev ===---

--require'windbg'.setup({
--cdb_path = '$SYSTEMDRIVE\\Program Files (x86)\\Windows Kits\\10\\Debuggers\\x64\\cdb.exe',
--windbg_path = '$LOCALAPPDATA\\Microsoft\\WindowsApps\\WinDbgX.exe',
--devmode = true,
--windbg_log_file = vim.fn.tempname()..'.windbg_out.log',
--plugin_log_file = vim.fn.tempname()..'.windbg_plg.log',
--})

---=== graphics ===---

if vim.g.neovide then
	vim.g.neovide_padding_top = 10
	vim.g.neovide_padding_left = 20
	vim.g.neovide_padding_right = 20
	vim.g.neovide_fullscreen = true
end

--vim.o.guifont = 'Agave Nerd Font:h13'
vim.o.guifont = "FiraCode Nerd Font:h11"
vim.o.linespace = -1
vim.o.relativenumber = true
vim.o.number = true
vim.o.hlsearch = false

local colorschemes = require("colorschemes")
colorschemes.setup(lualine, lualine_cfg)

---=== behaviour ===---

--vim.o.scrolloff = 777 -- keep cursor at center
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.formatoptions = "jql" -- do not autoinsert comment leader at newline
vim.o.splitright = true

---=== mappings ===---
vim.keymap.set("n", "<S-CR>", "o<Esc>")

vim.cmd("imap <Ins> <Esc>")
vim.cmd("tmap <Esc> <C-\\><C-n>")

vim.keymap.set("n", "<F1>", require("oil").open_float) -- open dir with current file
vim.keymap.set("n", "<S-F1>", ":Alpha<CR>")

vim.keymap.set("n", "<F2>", require("telescope.builtin").find_files)
vim.keymap.set("n", "<A-F2>", require("telescope.builtin").buffers)
vim.keymap.set("n", "<S-F2>", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<F4>", ":40vnew +nmap\\ \\<buffer\\>\\ \\<Esc\\>\\ \\<C-w\\>c $LOCALAPPDATA/nvim/keys.md<CR>")
vim.cmd("map <S-F4> :Telescope help_tags<CR>")

-- <F5> was set by nvim-launchpad
vim.cmd("map <F6> :lua vim.diagnostic.setqflist()<CR>")

vim.cmd("map <F8> :wall<CR>:source %<CR>") -- source current file to Vim
vim.cmd('map <S-F8> :wall<CR>:!powershell -command "Start-Process neovide.exe %"<CR><CR>:qall<CR>') -- restart with current file
vim.cmd('map <A-F8> "lyy:lua <C-r>l<CR>')
-- <C-F8> for project-specific re-soure

vim.keymap.set("n", "<S-F12>", colorschemes.switch)

---=== greeter ===---

if not vim.g.my_project then
	require("greeter").show()
end

---=== globals ===---

vim.g.my_project = "?"
