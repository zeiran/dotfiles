
return {show = function()

    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = {
        [[ ███▄    █ ▓█████ ▒█████   ██▒   █▓  ██  ███▄ ▄███▓]],
        [[ ██ ▀█   █ ▓█   ▀▒██▒  ██▒▓██░   █▒▒▓██ ▓██▒▀█▀ ██▒]],
        [[▓██  ▀█ ██▒▒███  ▒██░  ██▒ ▓██  █▒░░▒██ ▓██    ▓██░]],
        [[▓██▒  ▐▌██▒▒▓█  ▄▒██   ██░  ▒██ █░░ ░██ ▒██    ▒██ ]],
        [[▒██░   ▓██░░▒████░ ████▓▒░   ▒▀█░   ░██▒▒██▒   ░██▒]],
        [[░ ▒░   ▒ ▒ ░░ ▒░ ░ ▒░▒░▒░    ░ ▐░   ░▓ ░░ ▒░   ░  ░]],
        [[░ ░░   ░ ▒░ ░ ░    ░ ▒ ▒░    ░ ░░    ▒ ░░  ░      ░]],
        [[   ░   ░ ░    ░  ░ ░ ░ ▒       ░░    ▒  ░      ░   ]],
        [[         ░    ░      ░ ░        ░    ░ ░       ░   ]],
    }

    local dev_dir = 'C:\\dev';

    dashboard.section.buttons.val = {
        dashboard.button("i", "init.lua", ":e $MYVIMRC<CR>"),
        dashboard.button("d", "dev/", ":cd! c:\\dev\\<CR>:e .<CR>"),
        dashboard.button("w", "windbg", ':source '..dev_dir..'\\nvim-windbg\\_proj.lua<CR>'),
        dashboard.button("l", "lua-host", ':source '..dev_dir..'\\lua-host\\_vim.lua<CR>'),
        dashboard.button("e", "seqtrace", ":cd! c:\\dev\\exceptional_control\\<CR>:source _vim.lua<CR>:e .<CR>"),
    }

    dashboard.section.footer.val = '                                                                              ~(^._.)'

    dashboard.config.opts.noautocmd = true

    alpha.setup(dashboard.config)
    vim.cmd.Alpha()

end}
