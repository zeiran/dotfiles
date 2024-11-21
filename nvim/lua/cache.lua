
local M = {}

local cache = nil
local path = vim.fn.stdpath('cache')..'\\__cache.lua'

local function load()
    if not cache then
        local result
        result, cache = pcall(dofile, path)
        if not result then
            cache = {}
            vim.notify('cache is empty: '..path)
        end
    end
end

function M.get(key)
    load()
    return assert(cache)[key]
end

function M.set(key, val)
    load()
    cache[key] = val
    local f = io.open(path, 'w+')
    assert(f):write('return '..vim.inspect(cache))
    assert(f):close()
    return val
end

function M.purge()
    os.remove(path)
    cache = {}
end

function M.view()
    vim.cmd.edit(path)
end

return M
