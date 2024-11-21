local M = {}

local schemes = {}
local cache = require'cache'
local scheme_index = 1

local barbar = nil
local lualine = nil
local lualine_cfg = {}

local function set()
    local scheme = schemes[scheme_index]
    if type(scheme) == 'table' then
        scheme[2]()
        return scheme[1]
    else
        vim.cmd.colorscheme(scheme)
        return scheme
    end
end

function M.setup(lualine_, lualine_cfg_, barbar_)
    lualine = lualine_
    lualine_cfg = lualine_cfg_
    barbar = barbar_
    schemes = {
        {'neon', function() lualine_cfg['theme'] = "neon"; vim.g.neon_style = "default"; vim.cmd.colorscheme('neon') end},
        {'neon/dark', function() lualine_cfg['theme'] = "neon"; vim.g.neon_style = "dark"; vim.cmd.colorscheme('neon') end},
        'evergarden',
        'substrata',
    }
    scheme_index = cache.get('scheme_index') or 1
    if scheme_index + 1 > #schemes then
        scheme_index = 1
        cache.set('scheme_index', scheme_index)
    end
    set()
end

function M.switch()
    scheme_index = (scheme_index + 1 > #schemes) and 1 or scheme_index + 1
    vim.notify(set())
    assert(barbar).setup()
    assert(lualine).setup(lualine_cfg)
    cache.set('scheme_index', scheme_index)
end

return M
