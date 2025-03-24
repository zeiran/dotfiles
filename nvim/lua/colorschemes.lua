local M = {}

local schemes = {}

local lualine = nil
local lualine_cfg = {}

require("everforest").setup({background = "hard"})

local function set()
    local scheme = schemes[vim.g.MY_COLOR_INDEX]
    vim.o.background='dark'
    if type(scheme) == 'table' then
        scheme[2]()
        scheme = scheme[1]
    end
    local c = string.gsub(scheme, '/.*', '')
    vim.cmd.colorscheme(c)
    assert(lualine).setup(lualine_cfg)
    return scheme
end

function M.setup(lualine_, lualine_cfg_)
    lualine = lualine_
    lualine_cfg = lualine_cfg_
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
    vim.notify('index '..vim.inspect(vim.g.MY_COLOR_INDEX))
    vim.g.MY_COLOR_INDEX = vim.g.MY_COLOR_INDEX or 1
    if vim.g.MY_COLOR_INDEX + 1 > #schemes then
        vim.g.MY_COLOR_INDEX = 1
    end
    vim.api.nvim_create_autocmd({"VimEnter"}, {callback = set})
end

function M.switch()
    vim.g.MY_COLOR_INDEX = (vim.g.MY_COLOR_INDEX + 1 > #schemes) and 1 or vim.g.MY_COLOR_INDEX + 1
    vim.notify('colorscheme '..set())
    --assert(barbar).setup()
end

return M
