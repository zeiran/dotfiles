vim.notify("--- sandbox ---")

local group_name = "buffer-mru"
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  group = group_name,
  pattern = {"*.c", "*.h"},
  callback = function(ev)
    print(string.format('event fired: %s', vim.inspect(ev)))
  end
})

vim.notify("--- !sandbox ---")
