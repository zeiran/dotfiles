Dap = require("dap")
DapUi = require("dapui")

vim.keymap.set("n", "<Leader>db", Dap.toggle_breakpoint, { desc = "[debug] toggle breakpoint" })
vim.keymap.set("n", "<F9>", Dap.toggle_breakpoint, { desc = "[debug] toggle breakpoint" })
vim.keymap.set("n", "<Leader>dc", Dap.continue, { desc = "[debug] start/continue" })
--vim.keymap.set('n', '<F5>', Dap.continue, {desc='[debug] start/continue'})
vim.keymap.set("n", "<F10>", Dap.step_over, { desc = "[debug] step over" })
vim.keymap.set("n", "<C-F10>", Dap.step_into, { desc = "[debug] step into" })
vim.keymap.set("n", "<S-F10>", Dap.step_out, { desc = "[debug] step out" })

vim.keymap.set("n", "<F12>", function()
	DapUi.toggle({ layout = 1, reset = true })
end, { desc = "[debug] toggle UI (vars & console)" })
vim.keymap.set("n", "<S-F12>", DapUi.toggle, { desc = "[debug] toggle UI (all)" })
vim.keymap.set({ "n", "v" }, "<Leader>de", DapUi.eval, { desc = "[debug] eval at cursor / selection" })
vim.keymap.set({ "n", "v" }, "<F11>", DapUi.eval, { desc = "[debug] eval at cursor / selection" })

Dap.adapters["pwa-chrome"] = { ---@diagnostic disable-line: missing-fields
	type = "server",
	host = "localhost",
	port = 34343,
}
Dap.adapters["pwa-node"] = { ---@diagnostic disable-line: missing-fields
	type = "server",
	host = "localhost",
	port = 34343,
	-- TODO it stops incorrectly when autostarted (???)
	-- you can jus run it manually with 'term js-debug-adapter 34343')
	--port = "${port}",
	--executable = {
	--command = "node",
	--detached = "false",
	--args = {"C:\\Users\\RobotComp.ru\\AppData\\Local\\nvim\\js-debug\\src\\dapDebugServer.js", "${port}"},
	--}
}

DapUi.setup({ ---@diagnostic disable-line: missing-fields
	layouts = {
		{
			elements = {
				{
					id = "scopes",
					size = 0.75,
				},
				{
					id = "console",
					size = 0.25,
				},
			},
			position = "right",
			size = 60,
		},
		{
			elements = {
				{
					id = "breakpoints",
					size = 0.25,
				},
				{
					id = "stacks",
					size = 0.25,
				},
				{
					id = "watches",
					size = 0.25,
				},
			},
			position = "left",
			size = 40,
		},
		{
			elements = {
				{
					id = "repl",
					size = 0.5,
				},
			},
			position = "bottom",
			size = 10,
		},
	},
})
