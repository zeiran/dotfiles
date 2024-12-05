
local M = {}

local build_term_buffer = nil
local build_term = nil

--- @param cmd_list table List of command-line args passed to `vim.system`
--- @param err_file string Path to error file (will be used in `cfile`)
function M.build(cmd_list, err_file)
    vim.cmd.wall()

    if not build_term_buffer then
        build_term_buffer = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(build_term_buffer, '[build]')
    end
    if not build_term then
        build_term = vim.api.nvim_open_term(build_term_buffer, {})
    end

    vim.api.nvim_chan_send(build_term, '\n\027[36;1;4m>> BUILD '..vim.fn.strftime("%d.%m.%y %X")..' : '..
        table.concat(cmd_list, ' ')..'\027[0m\n')

    local error_text = ''
    local output = function(err, data)
         assert(not err)
         if not data then return end
         vim.schedule(function()
             vim.api.nvim_chan_send(build_term, data)
         end)
         error_text = error_text..data
    end
    local system_obj = vim.system(cmd_list, {stdout = output, stderr = output}):wait()

    local err = assert(io.open(err_file, "w+"))
    err:write(error_text)
    err:close()
    vim.cmd.cfile(err_file)
    if system_obj.code == 0 then
        vim.cmd.cclose()
        return true
    else
        vim.cmd.copen()
        return false
    end
end

--- @param dir string CMake build directory
--- @param target string CMake target to build
function M.build_cmake(dir, target)
    local err_file = dir.."/errors.err"
    return M.build({'cmake', '--build', dir, '--target', target}, err_file)
end

return M

