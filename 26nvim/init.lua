local user = os.getenv("LOGNAME")
local kl = (user == "alexeev_ev@avp.ru")
print("USER=" .. user .. ", KL=" .. tostring(kl))

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
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.hlsearch = false

function ConfigureLuaServer() -- copied from `:help lspconfig-all`
	vim.lsp.config("lua_ls", {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using (most
					-- likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Tell the language server how to find Lua modules same way as Neovim
					-- (see `:h lua-module-load`)
					path = {
						"lua/?.lua",
						"lua/?/init.lua",
					},
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
						vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
					},
					-- Or pull in all of 'runtimepath'.
					-- NOTE: this is a lot slower and will cause issues when working on
					-- your own configuration.
					-- See https://github.com/neovim/nvim-lspconfig/issues/3189
					-- library = vim.api.nvim_get_runtime_file('', true),
				},
			})
		end,
		settings = {
			Lua = {},
		},
	})
end

---- Colorscheme

vim.pack.add({ "https://github.com/neanias/everforest-nvim" })
require("everforest").setup({
	background = "hard",
})
vim.cmd([[colorscheme everforest]])

---- Dynamic font

-- maps ctrl++, ctl+-, ctrl-shift-=
vim.pack.add({
	"https://github.com/tenxsoydev/size-matters.nvim",
})
require("size-matters").setup()

---- Leap

vim.pack.add({ "https://codeberg.org/andyg/leap.nvim" })
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set({ "x", "o" }, "x", "<Plug>(leap-next-to)")
vim.keymap.set({ "n" }, "S", "<Plug>(leap-from-window)")

---- Lualine

vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
})
require("lualine").setup({
	sections = {
		lualine_x = { "getcwd" },
		lualine_y = { "filetype", "encoding" },
		lualine_z = { "progress", "location" },
	},
	options = {
		theme = "auto",
	},
})

---- Telescope

-- sudo apt install ripgrep
-- sudo apt install fd-find
-- TODO install telescope-fzf-native.nvim or telescope-fzy-native.nvim ?
vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-telescope/telescope.nvim",
})

require("telescope").setup({
	defaults = {
		layout_strategy = "vertical",
		layout_config = { height = 0.99 },
	},
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<F2>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<F3>", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<F1>", function()
	builtin.buffers({ sort_mru = true, ignore_current_buffer = true })
end, { desc = "Telescope buffers" })

vim.pack.add({
	"https://github.com/natecraddock/telescope-zf-native.nvim",
})
require("telescope").load_extension("zf-native")

vim.pack.add({
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
})
require("telescope").load_extension("ui-select")

---- Mason

-- at home in Mason, install clang-format, clangd
-- at work, its already installed system-wide
vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
})
require("mason").setup()

---- Conform (formatting)

vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})
local formatter = "clang-format"
if kl then
	formatter = "clang-format-18"
end
require("conform").setup({
	formatters_by_ft = {
		cpp = { "clang-format" },
		lua = { "stylua" },
	},
	formatters = {
		["clang-format"] = {
			command = formatter,
		},
	},
	format_on_save = {
		timeout_ms = 500,
	},
})

--- LSP configs

-- symlink your compile_commands.json to project root

vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
})
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
ConfigureLuaServer()

vim.keymap.set("n", "<F5>", vim.diagnostic.open_float, { desc = "LSP diagnostics open float" })
vim.keymap.set("n", "<S-F5>", vim.diagnostic.setqflist, { desc = "LSP diagnostics to quickfix" })

vim.keymap.set("n", "<S-F3>", function()
	builtin.lsp_dynamic_workspace_symbols({ symbols = { "struct", "class" } })
end, { desc = "Telescope LSP types" })

--- Blink completion

vim.pack.add({
	"https://github.com/saghen/blink.lib",
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
})
local cmp = require("blink.cmp")
--cmp.build():pwait() -- it's for v2
cmp.setup()

--- Oil

vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
})
local oil = require("oil")
oil.setup({
	view_options = {
		show_hidden = true,
	},
})
vim.keymap.set("n", "<F4>", oil.open, { desc = "Open file dir" })

---- CMake

vim.pack.add({
	"https://github.com/Civitasv/cmake-tools.nvim",
})
require("cmake-tools").setup({
	cmake_regenerate_on_save = false,
	cmake_executor = {
		name = "quickfix",
		opts = { size = 30 },
	},
})

vim.keymap.set("n", "<F7>", ":CMakeBuild<CR>", { desc = "CMake build" })
vim.keymap.set("n", "<C-F7>", ":CMakeSelectBuildTarget<CR>", { desc = "Cmake select build target" })
vim.keymap.set("n", "<S-F7>", ":CMakeQuickBuild<CR>", { desc = "Cmake quick build" })

vim.keymap.set("n", "<F8>", ":CMakeRun<CR>", { desc = "CMake run" })
vim.keymap.set("n", "<C-F8>", ":CMakeSelectLaunchTarget<CR>", { desc = "Cmake select launch target" })
vim.keymap.set("n", "<S-F8>", ":CMakeQuickRun<CR>", { desc = "Cmake quick run" })

---- Escalator
vim.pack.add({
	"https://github.com/zeiran/escalator.nvim",
})
require("escalator").setup({})

vim.keymap.set("n", "<F12>", ":EscalatorToggle<CR>", { desc = "Escalator toggle" })
