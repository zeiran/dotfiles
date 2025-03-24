local len = 30
local numbers = "~1234567890QWERTYUIOPASDFGHJKLZXCVBNM"
local counter = 0

vim.keymap.set("n", "<A-Del>", ":b#<bar>bd#<CR>")
vim.keymap.set("n", "<A-->", ':let b:buf_mru_key=""<Left>')

local function format_buf_line(i, bufnr)
	local s = string.sub(vim.api.nvim_buf_get_name(bufnr), -len)
	if #s == len then
		s = "..." .. string.sub(s, -len + 3)
	else
		s = string.rep(" ", len - #s) .. s
	end
	if i < #numbers then
		local letter = numbers:sub(i, i)
		s = s .. "  " .. letter
		vim.keymap.set("n", "<A-" .. letter .. ">", ":" .. bufnr .. "b<CR>")
	end
  local found, hotkey = pcall(vim.api.nvim_buf_get_var, bufnr, 'buf_mru_key')
  if found then
    s = s..' '..hotkey
		vim.keymap.set("n", "<A-" .. hotkey .. ">", ":" .. bufnr .. "b<CR>")
  end
	return s
end

--- @class BufEntry
--- @field timestamp? number

--- @type table<number,number>
local buffers = {}

--- @param enteredBuffer? integer
--- @return string[]
local function format_buf_lines(enteredBuffer)
	local lines = { "", tostring(counter), "", "", "", "" }
	counter = counter + 1

	--- @type table<integer, integer>
	local new_buffers = {}

	local sorted_buffers = {}

	local bs = vim.api.nvim_list_bufs()
	for _, b in ipairs(bs) do
		if vim.fn.buflisted(b) == 1 then
			local val
			if b == enteredBuffer then
				val = counter
			else
				val = buffers[b] or 0
			end
			table.insert(sorted_buffers, { bufnr = b, val = val })
			new_buffers[b] = val
		end
	end
	buffers = new_buffers

	table.sort(sorted_buffers, function(l, r)
		return l.val > r.val
	end)

	for i, buffer in ipairs(sorted_buffers) do
		table.insert(lines, format_buf_line(i, buffer.bufnr))
	end
	return lines
end

local bufnr

--print(vim.inspect(bufs))
local function toggle_buffer_mru_win()
	bufnr = vim.g.zr_bufnr
	if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
		bufnr = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(bufnr, "[buffer-mru]")
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, format_buf_lines())
		vim.g.zr_bufnr = bufnr
	end
	local winnr = vim.g.zr_winnr

	if winnr and vim.api.nvim_win_is_valid(winnr) and vim.api.nvim_win_get_buf(winnr) == bufnr then
		vim.api.nvim_win_close(winnr, false)
	else
		winnr = vim.api.nvim_open_win(bufnr, false, {
			split = "left",
			focusable = false,
			width = len + 6,
		})
		vim.g.zr_winnr = winnr
		vim.api.nvim_set_option_value("cursorline", false, { win = winnr })
		vim.api.nvim_set_option_value("number", false, { win = winnr })
		vim.api.nvim_set_option_value("relativenumber", false, { win = winnr })
		vim.api.nvim_set_option_value("winfixwidth", true, { win = winnr })
		vim.fn.win_execute(winnr, 'syn match Ignore ".*[\\\\/]"')
		vim.fn.win_execute(winnr, 'syn match Tag "  \\d\\+"')
		--print(bufnr)
	end
end

vim.keymap.set("n", "<A-=>", toggle_buffer_mru_win, { desc = "[buf-mru] toggle MRU buffer window" })

local group_name = "buffer-mru"
vim.api.nvim_create_augroup(group_name, { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = group_name,
	desc = "[buf-mru] reorders buffers in MRU list",
	callback = function(args)
		if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
			vim.defer_fn(function()
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, format_buf_lines(args.buf))
			end, 0)
		end
	end,
})
