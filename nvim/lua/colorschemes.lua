local M = {}

local schemes = {}
local cache = require'cache'
local scheme_index = 1

local barbar = nil
local lualine = nil
local lualine_cfg = {}

local function set()
    local scheme = schemes[scheme_index]
    vim.o.background='dark'
    if type(scheme) == 'table' then
        scheme[2]()
        scheme = scheme[1]
    end
    local c = string.gsub(scheme, '/.*', '')
    vim.cmd.colorscheme(c)
    return scheme
end

function M.setup(lualine_, lualine_cfg_, barbar_)
    lualine = lualine_
    lualine_cfg = lualine_cfg_
    barbar = barbar_
    schemes = {
        {'neon', function() lualine_cfg['theme'] = "neon"; vim.g.neon_style = "default" end},
        {'neon/dark', function() lualine_cfg['theme'] = "neon"; vim.g.neon_style = "dark" end},
        'substrata',
        'no-clown-fiesta',
        'gruvbox-material',
        {'gruvbox-material/light', function() vim.o.background='light' end},
        'evergarden',
        'everforest',
        --{'everforest/soft', function() vim.g.everforest_background='soft' end},
        --{'everforest/hard', function() vim.g.everforest_background='hard' end},
        {'everforest/light', function() vim.o.background='light' end},
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
    vim.notify('colorscheme '..set())
    assert(barbar).setup()
    assert(lualine).setup(lualine_cfg)
    cache.set('scheme_index', scheme_index)
end

return M
