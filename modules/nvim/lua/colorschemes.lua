local colorscheme = "space_vim"

if colorscheme == "space_vim" then
    vim.cmd [[colorscheme space_vim_theme]]
elseif colorscheme == "tokyo_night" then
    require("tokyonight").setup({
        style = "moon",
        transparent = false,
        terminals_colors = true,
        styles = {
            comments = { italic = true},
            keywords = { italic = true},
            sidebars = "dark",
            floats = "dark",
        },
        hide_inactive_statusline = false,
        on_highlights = function(hl, _)
            hl.LineNr = { fg = "#af87d7",}
        end,

    })
    vim.cmd [[colorscheme tokyonight]]
elseif colorscheme == "rose-pine" then
    require("rose-pine").setup({
        dark_variant = 'moon',
    })
    vim.cmd [[colorscheme rose-pine]]
end
