--[[

Enable debug:
vim.lsp.set_log_level('debug')

--]]

-- NOTE: Leader key must be set before plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.cmd([[map <BS> <Leader>]])

-- Download plug.vim if it doesn't exist yet
local plugpath = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
if not vim.loop.fs_stat(plugpath) then
    vim.fn.system {
        'curl',
        '-fLo',
        plugpath,
        '--create-dirs',
        'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    }
end
vim.opt.rtp:prepend(plugpath)

do
    -- Run PlugInstall if there are missing plugins
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        -- [[ ]] are string delimiters
        command = [[
            if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) > 0 | PlugInstall --sync | source $MYVIMRC | endif
        ]],
        pattern = '*',
        group = vim.api.nvim_create_augroup('PlugInstallGrp', { clear = true })
    })

    local vim = vim
    local Plug = vim.fn['plug#']

    vim.call('plug#begin')
    Plug('glacambre/firenvim', { ['do'] = function()
        vim.fn['firenvim#install'](0)
    end })
    Plug('girishji/pythondoc.vim')
    --
    Plug('rafamadriz/friendly-snippets')
    Plug('hrsh7th/nvim-cmp')
    Plug('hrsh7th/vim-vsnip')
    Plug('hrsh7th/cmp-vsnip')
    Plug('hrsh7th/cmp-buffer')
    Plug('hrsh7th/cmp-path')
    Plug('hrsh7th/cmp-cmdline')
    --
    -- Plug('~/my-prototype-plugin')
    vim.call('plug#end')
end

-- Firenvim
-- https://www.reddit.com/r/neovim/comments/1b9nyt5/has_anyone_successfully_embedded_nvim_in_leetcode/
-- When chrome/firefox starts Neovim, Firenvim sets the variable g:started_by_firenvim
-- Only leetcode has automatic access, for other sites click <command-E>
if vim.g.started_by_firenvim then
    -- vim.o.guifont = 'FiraCode Nerd Font:h24'
    vim.o.guifont = 'FiraCode Nerd Font:h22'
    -- vim.o.guifont = 'Fira Code:h18'
    vim.o.linespace = 0
    vim.o.laststatus = 0
    -- Prepend it with 'silent!' to ignore errors when it's not yet installed.
    vim.cmd('silent! colorscheme zellner')

    vim.api.nvim_create_autocmd('BufEnter', {
        pattern = '*leetcode.com_*.txt',
        callback = function()
            local bufname = vim.fn.bufname '%'
            if bufname:match 'leetcode.com_.*%.txt' then
                vim.bo.filetype = 'python'
                vim.cmd 'syntax enable'
                vim.cmd 'set syntax=python'
            end
        end,
    })
end

-- nvim-cmp
do
    local cmp = require'cmp'

    local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            end,
        },
        mapping = cmp.mapping.preset.insert {
            ['<C-d>'] = cmp.mapping.scroll_docs(-4), -- next to [f]
            ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- [f]orward
            ['<C-Space>'] = cmp.mapping.complete {},
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            },
            -- Supertab
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                    -- elseif luasnip.jumpable(1) then
                    -- luasnip.jump(1)
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                    -- elseif luasnip.jumpable(-1) then
                    --   luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        },
        window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources({
            { name = 'buffer', max_item_count = 10 },
            { name = 'path' },
            { name = 'vsnip', max_item_count = 15 },
        }),
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer', max_item_count = 20 }
        }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
    })

    -- -- Set up lspconfig.
    -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
    --   capabilities = capabilities
    -- }
end

-- Set Options
-- See `:help vim.o`
do
    vim.o.hlsearch = true -- Set highlight on search
    vim.wo.number = true  -- Make line numbers default
    -- vim.wo.relativenumber = true
    -- vim.o.mouse = 'a' -- Enable mouse mode
    vim.o.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim. See `:help 'clipboard'`
    vim.o.breakindent = true        -- Enable break indent
    vim.o.undofile = false          -- Save undo history (XXX: better to not go back too deep when typing 'u')
    vim.o.ignorecase = true         -- Case insensitive searching UNLESS /C or capital in search
    vim.o.smartcase = true
    -- vim.o.winbar = "%=%m %F"  --  Winbar
    -- vim.wo.signcolumn = 'yes' -- Keep signcolumn on by default
    -- Decrease update time
    -- vim.o.updatetime = 250
    -- vim.o.timeout = true
    -- vim.o.timeoutlen = 300

    vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
    -- vim.o.shiftwidth = 2
    -- vim.o.expandtab = true
    vim.o.scrolloff = 4
    vim.o.sidescrolloff = 4
    -- vim.o.shada = "!,%,'100,<50,s10,h" -- '%' to store the buffers (invoke nvim without filename)
end

-- Abbreviations
-- To avoid the abbreviation in Insert mode: Type CTRL-V before the character
-- that would trigger the abbreviation. To avoid the abbreviation in
-- Command-line mode: Type CTRL-V twice somewhere in the abbreviation to avoid
-- it to be replaced.
vim.cmd [[
    " Consume the space typed after an abbreviation (:h abbreviation)
    func! Eatchar(pat)
        let c = nr2char(getchar(0))
        return (c =~ a:pat) ? '' : c
    endfunc

    augroup vimrcgrp | autocmd!
        au BufNewFile,BufRead *.c,*.cpp,*.java
        \   iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>
        \ | iabbr <silent> while while ()<Left><C-R>=Eatchar('\s')<CR>
        au BufNewFile,BufRead *.md,*.txt
        \   iabbr <silent> --- ----------------------------------------<C-R>=Eatchar('\s')<CR>
    augroup END
]]

-- [[ Keymaps ]]

do
    local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- [[ Basic Keymaps ]]

    map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

    -- g* selects foo in foobar while * selects <foo>, <> is word boundary. make * behave like g*
    -- map('n', '*', 'g*', { silent = true })
    -- map('n', '#', 'g#', { silent = true })

    -- Write and quit
    map({ 'n', 'v' }, '<leader>w', '<cmd>write<cr>', { desc = '[W]rite buffer' })
    map({ 'n', 'v' }, '<leader>q', '<cmd>qa<cr>', { desc = '[Q]uit all' })
    map({ 'n', 'v' }, '<leader>Q', '<cmd>q!<cr>', { desc = '[Q]uit without saving' })

    -- Remap for dealing with word wrap
    map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
    map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

    -- For better buffer navigation
    -- map('n', '[[', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
    -- map('n', ']]', '<cmd>bnext<cr>', { desc = 'Next buffer' })
    map('n', '<leader>d', '<cmd>bdelete<cr>', { desc = '[D]elete buffer' })
    map('n', '<leader>b', '<cmd>e #<cr>', { desc = 'Switch to alternate(#) [b]uffer' })
    -- map('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

    -- Move to window using the <ctrl> hjkl keys
    map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
    map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
    map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
    map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

    -- Resize window using <ctrl> arrow keys
    map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
    map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
    map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
    map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

    -- better indenting
    map("v", "<", "<gv")
    map("v", ">", ">gv")

    -- windows (see C-w keymaps)
    map("n", "<leader>o", "<C-W>w", { desc = "Other window" })
    map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
    map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

    -- gs reselect last modified chunk (including pasted)
    vim.cmd [[ nnoremap <expr> gs '`[' . getregtype()[0] . '`]' ]]

    -- LSP hover windows do not close unless you press h,j,k,l. Close every floating window on <esc>
    -- Also, clear hlsearch
    local close_floating_windows = function()
        for _, win in pairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative == 'win' then
                vim.api.nvim_win_close(win, false)
            end
        end
        vim.cmd([[noh]])
    end
    map("n", "<esc>", function() close_floating_windows() end, { desc = nil })

    -- Redirect output of Ex command (XXX: nothing shows up in Ex until you start typing; using vimscript solves this)
    -- map({ 'n' }, "<leader>vr", ":put = execute('')<left><left>", { desc = "[R]edirect output of cmd (see also 'redir')" })
    vim.cmd [[nmap <leader>vr :put = execute('')<left><left>]]

    -- vim commands
    -- map({ 'n' }, "<leader>vb", "<cmd>ls<cr>", { desc = "Show (listed) [b]uffers (:ls)" }) -- :buffers same as :ls
    -- map({ 'n' }, "<leader>vB", "<cmd>ls!<cr>", { desc = "Show all [b]uffers (:ls!)" })    -- :buffers same as :ls
    -- map({ 'n' }, "<leader>vl", "<cmd>set buflisted<cr>", { desc = "[L]ist current buffer in buffer list" })
    -- map({ 'n' }, "<leader>vu", "<cmd>set nobuflisted<cr>", { desc = "[U]nlist current buffer" })
    -- Print full path of file in current buffer
    -- map({ 'n', 'v' }, "<leader>vp", function() print(vim.fn.expand('%:p')) end,
    --   { desc = "Show full [p]ath of current buffer" })
    -- list loaded modules
    -- map({ 'n' }, "<leader>vL", function() vim.notify(vim.inspect(package.loaded)) end, { desc = "[L]ist loaded modules" })
end

-- -- [[ python keybindings ]]
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "python",
--   callback = function(args)
--     local map = function(lhs, rhs, desc)
--       vim.keymap.set('n', lhs, rhs, { buffer = args.buf, desc = desc })
--     end
--     map("<leader>ce", "<cmd>update<CR><cmd>exec '!python3' shellescape(@%, 1)<cr>", "Run")
--     map("<leader>ci",
--       "<cmd>cexpr system('refurb --quiet ' . shellescape(expand('%'))) | copen<cr>",
--       "Inspect using refurb")
--     map("<leader>cp", "<cmd>lua _IPYTHON_TOGGLE()<cr>", "iPython")
--   end
-- })

-- toggle options
do
    local toggle_opt = function(option)
        vim.opt_local[option] = not vim.opt_local[option]:get()
    end
    local diag_enabled = true
    local toggle_diagnostics = function()
        diag_enabled = not diag_enabled
        if diag_enabled then
            vim.diagnostic.enable()
        else
            vim.diagnostic.disable()
        end
    end
    local nmap = vim.keymap.set
    nmap("n", "<leader>us", function() toggle_opt("spell") end, { desc = "Toggle Spelling" })
    nmap("n", "<leader>ud", toggle_diagnostics, { desc = "Toggle Diagnostics" })
end

-- [[ Create autocommands ]]
do
    local my_aucmd_group = vim.api.nvim_create_augroup('MyCommands', { clear = true })

    -- [[ Highlight on yank ]]
    -- See `:help vim.highlight.on_yank()`
    vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
            vim.highlight.on_yank({ timeout = 400 })
        end,
        group = my_aucmd_group,
        pattern = '*',
    })

    -- -- [[ go to last cursor loc when opening a buffer ]]
    -- vim.api.nvim_create_autocmd(
    -- "BufReadPost",
    -- { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
    -- )

    -- -- [[ Check if we need to reload the file when it changed ]]
    -- vim.api.nvim_create_autocmd("FocusGained", {
    --     command = [[:checktime]],
    --     group = my_aucmd_group,
    -- })

    -- -- [[ windows to close ]]
    -- vim.api.nvim_create_autocmd("FileType", {
    --     pattern = {
    --         "help",
    --         "startuptime",
    --         "qf",
    --         "lspinfo",
    --         "vim",
    --         "fugitive",
    --         "git",
    --         "neotest-summary",
    --         "query",
    --         "neotest-output",
    --         "spectre_panel",
    --         "tsplayground",
    --     },
    --     callback = function(event)
    --         vim.bo[event.buf].buflisted = false
    --         vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    --     end,
    -- })
    -- vim.api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })
    -- vim.api.nvim_create_autocmd("FileType", { pattern = "cheat", command = [[nnoremap <buffer><silent> q :bdelete!<CR>]] })

    -- -- [[ don't auto comment new line ]]
    -- vim.api.nvim_create_autocmd("BufEnter", {
    --     group = my_aucmd_group,
    --     command = [[set formatoptions-=cro]]
    -- })

    -- -- [[ create directories when needed, when saving a file ]]
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --     group = my_aucmd_group,
    --     command = [[call mkdir(expand('<afile>:p:h'), 'p')]],
    -- })
end
