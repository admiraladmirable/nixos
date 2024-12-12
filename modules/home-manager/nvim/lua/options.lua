local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
