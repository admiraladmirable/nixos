local options = {
    fileencoding = "utf-8",
    wrap = false,
    tabstop = 4,
    clipboard = "unnamedplus",
    number = true,
    relativenumber = false,
    numberwidth = 4,
    backup = false,
    history = 200,
    splitbelow = true,
    splitright = true,
    autoread = true,
    shiftwidth = 4,
    expandtab = true,
    softtabstop = 4,
    scrolloff = 20,
    sidescrolloff = 8,
    incsearch = true,
    smartcase = true,
    ignorecase = true,
    hlsearch = true,
    swapfile = false,
    conceallevel = 0,
    pumheight = 10,
    showtabline = 1,
    timeoutlen = 300,
    undofile = true,
    undodir = "/home/rick-desktop/.local/share/nvim/undo",
    updatetime = 300,
    writebackup = false,
    termguicolors = true,
    mouse = "",
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal",
    completeopt = "menu,menuone,noselect"
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.cmd [[set iskeyword+=-]]
vim.cmd [[set cmdheight=0]]
vim.cmd [[let g:NERDCommentEmptyLines = 1]]
vim.opt.shortmess:append("cI")

--Set LSP output
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    float = { source = "always", border = "single" },
})

--LuaLine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    --lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_x = {nil},
    lualine_y = {nil},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

--Closetags
vim.g.closetag_filenames = '*.html, *.xhtml, *.phtml'
vim.g.closetag_filetypes = 'html,xhtml,phtml'
vim.g.closetag_close_shortcut = '<leader>>'
-- Floatterm Inits
vim.cmd [[let g:floaterm_keymap_toggle = '<F1>']]
vim.cmd [[autocmd VimEnter * :FloatermNew! --silent --name=main --height=30 --position=right --width=0.4 cd %:p:h | clear ]]
--vim.cmd [[autocmd VimEnter *.js,*.html,*.css,*.ts :FloatermNew! --silent --name=webserve --cwd=<root> python3 -m http.server 8000]]
--vim.cmd [[autocmd BufWrite *.cpp,*h :FloatermSend --silent --name=main make]]
--Commands
vim.cmd[[command! -nargs=1 -complete=help Help :tabnew | :enew | :set buftype=help | :h <args>]]
vim.cmd[[command! SS echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')]]
