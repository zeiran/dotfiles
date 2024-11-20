
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

    dashboard.section.buttons.val = {
        dashboard.button("i", "init.lua", ":e $MYVIMRC<CR>"),
        dashboard.button("d", "dev/", ":cd! c:\\dev\\<CR>:e .<CR>"),
        dashboard.button("e", "seqtrace", ":cd! c:\\dev\\exceptional_control\\<CR>:source _vim.lua<CR>:e .<CR>"),
    }

    dashboard.section.footer.val = '                                                                              ~(^._.)'

    dashboard.config.opts.noautocmd = true

    alpha.setup(dashboard.config)
    vim.cmd.Alpha()

end}
