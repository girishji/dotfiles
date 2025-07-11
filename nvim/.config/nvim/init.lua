--[[
Folding:
foldmethod is 'indent' and foldnestmax is 1
zr: 'r'educe (unfold) all folds
zm: 'm'ore (fold) file
za: toggle fold under cursor
]z and [z work as well

Enable debug:
vim.lsp.set_log_level('debug')
--]]

-- NOTE: Leader key must be set before plugins
do
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    vim.cmd([[map <BS> <Leader>]])
end

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

    local Plug = vim.fn['plug#']

    vim.call 'plug#begin'
    Plug('glacambre/firenvim', { ['do'] = function()
        vim.fn['firenvim#install'](0)
    end })
    Plug 'girishji/pythondoc.vim'
    Plug '~/git/devdocs.vim'
    --
    -- Plug('rafamadriz/friendly-snippets')
    Plug 'hrsh7th/nvim-cmp'
    -- Plug('hrsh7th/vim-vsnip')
    -- Plug('hrsh7th/cmp-vsnip')
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    -- Plug 'hrsh7th/cmp-nvim-lsp'
    -- Plug 'neovim/nvim-lspconfig'
    --
    -- Plug('~/my-prototype-plugin')
    Plug 'miikanissi/modus-themes.nvim'
    vim.call 'plug#end'
end


-- Set Options
-- See `:help vim.o`
do
    vim.o.shortmess = vim.o.shortmess .. 'I'
    vim.o.hlsearch = true -- Set highlight on search
    vim.wo.number = true  -- Make line numbers default
    -- vim.wo.relativenumber = true
    -- vim.o.mouse = 'a' -- Enable mouse mode
    vim.o.clipboard = 'unnamed'
    vim.o.foldmethod = 'indent'
    vim.o.foldnestmax = 1
    vim.o.foldenable = false  -- do not do folding when you open file
    vim.o.breakindent = true
    vim.o.ignorecase = true
    vim.o.smartcase = true
    vim.o.linebreak = true
    vim.o.joinspaces = false
    vim.o.showmatch = true
    vim.o.grepprg = 'grep -REIins --exclude=tags --exclude="*.swp" --exclude-dir=.git $*'
    vim.o.whichwrap = 'b,s,<,>,h,l' -- make arrows and h, l, push cursor to next line
    vim.o.virtualedit = 'block' -- allows selection of rectangular text in visual block mode
    vim.o.wildignore = '.gitignore,*.swp,*.zwc,tags'
    -- vim.o.winbar = "%=%m %F"
    vim.o.laststatus = 0  -- turn off statusline
    -- vim.cmd [[set rulerformat=%80(%<%f\ %h%m%r\ %=%-8y\ %-8.(%l,%c%V%)\ %P%)]]
    vim.cmd [[set ruf=%80(%=%f\ %h%m%r\ %-6y\ %-5.(%l,%c%V%)\ %P%)]]
    vim.api.nvim_create_autocmd("FileType", {
        pattern = {"lua", "cpp"},
        callback = function(args)
            vim.o.tabstop = 4
            vim.o.shiftwidth = 4
            vim.o.expandtab = true
        end
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "cpp",
        callback = function(args)
            vim.cmd [[setlocal commentstring=//\ %s]]
        end
    })
end

-- Abbreviations
-- To avoid the abbreviation in Insert mode: Type CTRL-V before the character
-- that would trigger the abbreviation. To avoid the abbreviation in
-- Command-line mode: Type CTRL-V twice somewhere in the abbreviation to avoid
-- it to be replaced.
vim.cmd [[
    " Consume the space typed after an abbreviation (:h abbreviation)
    func! Eatchar()
        let c = nr2char(getchar(0))
        return (c =~ '\s\|/') ? '' : c  " eat space and '/'
    endfunc

    iabbr  --* <esc>d^a<c-r>=repeat('-', getline(line('.') - 1)->trim()->len())<cr><c-r>=Eatchar()<cr>
    iabbr <silent> --- ----------------------------------------<C-R>=Eatchar()<CR>

    func! CppAbbr()
        iabbr <silent><buffer> fori_ for(int i=0; i<; i++) {<c-o>o}<esc>kf;;i<C-R>=Eatchar()<CR>
        iabbr <silent><buffer> forj_ for(int j=0; j<; j++) {<c-o>o}<esc>kf;;i<C-R>=Eatchar()<CR>
        iabbr <silent><buffer> fork_ for(int k=0; k<; k++) {<c-o>o}<esc>kf;;i<C-R>=Eatchar()<CR>
        iabbr <silent><buffer> forr_ for(auto& x : ) {<c-o>o}<esc>kf:la<C-R>=Eatchar()<CR>
        iabbr <silent><buffer> for_iter_ for(auto it=.begin(); it!=.end(); it++) {<c-o>o}<esc>kf.i<C-R>=Eatchar()<CR>
        iabbr <silent><buffer> for_each_ ranges::for_each(, [](int& n) {});<esc>16hi<C-R>=Eatchar()<CR>
        iabbr <silent><buffer> for_each_print_ ranges::for_each(, [](const int& n) {cout << n;});cout<<endl;<esc>F(;a<C-R>=Eatchar()<CR>
        iabbr <silent><buffer> print_range_ ranges::copy(x, ostream_iterator<int>(cout, " "));cout<<endl;<esc>Fxcw<C-R>=Eatchar()<CR>
        iabbr <silent><buffer> all_ a.begin(), a.end()<C-R>=Eatchar()<CR>
        iabbr <silent><buffer> max_element_ ranges::max_element(<C-R>=Eatchar()<CR>
        iabbr <silent><buffer> distance_ ranges::distance(<C-R>=Eatchar()<CR>
    endfunc

    func! LuaAbbr()
        iabbr <buffer>       function   function )<cr>end<esc>k-f)i<c-r>=Eatchar()<cr>
        iabbr <buffer>       if    if  then<cr>end<esc>k-e2li<c-r>=Eatchar()<cr>
        iabbr <buffer>       for   for _, x in ipairs() do<cr>end<esc>k-f(a<c-r>=Eatchar()<cr>
        iabbr <buffer>       for_  for  do<cr>end<esc>k-e2li<c-r>=Eatchar()<cr>
        iabbr <buffer>       while while  do<cr>end<esc>k-e2li<c-r>=Eatchar()<cr>
        iabbr <buffer>       vimf  vim.fn.<c-r>=Eatchar()<cr>
        iabbr <buffer>       vimc  vim.cmd [[<c-r>=Eatchar()<cr>
    endfunc

    func! s:GetSurroundingFn()
        let fpat = '\vdef\s+\zs\k+'
        let lnum = search(fpat, 'nb')
        if lnum > 0
            let fname = getline(lnum)->matchstr(fpat) . '()'
            let cpat = '\vclass\s+\zs\k+'
            let lnum = search(cpat, 'nb')
            if lnum > 0
                return getline(lnum)->matchstr(cpat) . '().' . fname
            endif
            return fname
        endif
        return ''
    endfunc

    func! PyAbbr()
        iabbr <buffer>       def   def ):<cr><esc>-f)i<c-r>=Eatchar()<cr>
        iabbr <buffer>       try_  try:<cr>
            \<cr>pass
            \<cr>except Exception as err:
            \<cr>print(f"Unexpected {err=}, {type(err)=}")
            \<cr>raise<cr>else:
            \<cr>pass<esc>5k_<c-r>=Eatchar()<cr>
        iabbr <buffer>       main__2
            \ if __name__ == "__main__":
            \<cr>import doctest
            \<cr>doctest.testmod()<esc><c-r>=Eatchar()<cr>
        iabbr <buffer>       main__
            \ if __name__ == "__main__":<cr>
            \<cr>main()<esc><c-r>=Eatchar()<cr>
        iabbr <buffer>       python3#    #!/usr/bin/env python3<esc><c-r>=Eatchar()<cr>
        iabbr <buffer>       '''_ '''
            \<cr>>>> print(<c-r>=<SID>GetSurroundingFn()<cr>)
            \<cr>'''<esc>ggOfrom sys import stderr<esc>Go<c-u><esc>o<esc>
            \:normal imain__2<space><esc>
            \?>>> print<cr>:nohl<cr>g_hi<c-r>=Eatchar()<cr>
        iabbr <buffer>       """            """."""<c-o>3h<c-r>=Eatchar()<cr>
        iabbr <buffer>       case_ match myval:<cr>
            \<cr>case 10:
            \<cr>pass
            \<cr>case _:<esc>3k_fm;i<c-r>=Eatchar()<cr>
        iabbr <buffer>       enum_          Color = Enum('Color', ['RED', 'GRN'])<esc>_fC<c-r>=Eatchar()<cr>
        iabbr <buffer>       pre            print(, file=stderr)<esc>F,i<c-r>=Eatchar()<cr>
        iabbr <buffer>       pr             print()<c-o>i<c-r>=Eatchar()<cr>
        iabbr <buffer>       namedtuple_    Point = namedtuple('Point', 'x y')<esc>_<c-r>=Eatchar()<cr>
        iabbr <buffer>       namedtuple__   Point = namedtuple('Point', ('x', 'y'), defaults=(None,) * 2)<esc>_<c-r>=Eatchar()<cr>
        iabbr <buffer>       tuple_         Point = namedtuple('Point', 'x y')<esc>_<c-r>=Eatchar()<cr>
        iabbr <buffer>       tuple__        Point = namedtuple('Point', ('x', 'y'), defaults=(None,) * 2)<esc>_<c-r>=Eatchar()<cr>
        iabbr  <buffer>  defaultdict_       defaultdict(int)<c-r>=Eatchar()<cr>
        iabbr  <buffer>  dict_default_      defaultdict(int)<c-r>=Eatchar()<cr>
        iabbr  <buffer>  defaultdict__      defaultdict(set)<c-r>=Eatchar()<cr>
        iabbr  <buffer>  dict_default__     defaultdict(set)<c-r>=Eatchar()<cr>
        iabbr  <buffer>  defaultdict___     defaultdict(lambda: '[default  value]')<c-r>=Eatchar()<cr>
        iabbr  <buffer>  dict_default___    defaultdict(set)<c-r>=Eatchar()<cr>
        iabbr <buffer>   cache_             @functools.cache<c-r>=Eatchar()<cr>
        iabbr <buffer>   __init__           def __init__(self):<esc>hi<c-r>=Eatchar()<cr>
        iabbr <buffer>   __add__            def __add__(self, other):<cr><c-r>=Eatchar()<cr>
        iabbr <buffer>   __sub__            def __sub__(self, other):<cr><c-r>=Eatchar()<cr>
        iabbr <buffer>   __mul__            def __mul__(self, other):<cr><c-r>=Eatchar()<cr>
        iabbr <buffer>   __truediv__        def __truediv__(self, other):<cr><c-r>=Eatchar()<cr>
        iabbr <buffer>   __floordiv__       def __floordiv__(self, other):<cr><c-r>=Eatchar()<cr>
    endfunc

    augroup vimrcgrp | autocmd!
        au BufNewFile,BufRead *.cpp call CppAbbr()
        au BufNewFile,BufRead *.py call PyAbbr()
        " XXX: nvim bug where if ft=python but file is foo.txt it will not load python abbr (for leetcode/firenvim)
        " au BufNewFile,BufRead *.txt call PyAbbr()
        au BufNewFile,BufRead *.txt call CppAbbr()
    augroup END
]]


-- Keymaps
do
    local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
    map({ 'n', 'v' }, '<leader>w', '<cmd>silent update<cr>', { desc = '[W]rite buffer' })
    map({ 'n', 'v' }, '<leader>q', '<cmd>qa<cr>', { desc = '[Q]uit all' })
    map({ 'n', 'v' }, '<leader>Q', '<cmd>qa!<cr>', { desc = '[Q]uit without saving' })
    local function defer_after(key, key2)
        vim.fn.feedkeys(key, 'nt')
        vim.defer_fn(function() vim.fn.feedkeys(key2, 'nt') end, 10)
    end
    map({ 'n', 'v' }, '<leader><bs>', function () defer_after(':b', ' ') end)
    map({ 'n', 'v' }, '<leader><space>', function () defer_after(':e *', '*') end)
    -- map({ 'n', 'v' }, '<leader><space>', function () defer_after(':find', ' ') end)

    -- Remap for dealing with word wrap
    map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
    map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

    -- For better buffer navigation
    -- map('n', '[[', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
    -- map('n', ']]', '<cmd>bnext<cr>', { desc = 'Next buffer' })
    map('n', '<leader>d', '<cmd>bdelete<cr>', { desc = '[D]elete buffer' })
    map('n', '<leader>b', '<cmd>e #<cr>', { desc = 'Switch to alternate(#) [b]uffer' })

    -- Move to window using the <ctrl> hjkl keys
    -- map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
    -- map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
    -- map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
    -- map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

    -- Resize window using <ctrl> arrow keys
    map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
    map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
    map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
    map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

    -- windows (see C-w keymaps)
    map("n", "<leader>o", "<C-W>w", { desc = "Other window" })
    map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
    map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })
    map('n', '<leader>n', "<C-W>o", { desc = 'Make the current window the [o]nly one' })

    -- gs reselect last modified chunk (including pasted)
    vim.cmd [[ nnoremap <expr> gs '`[' . getregtype()[0] . '`]' ]]

    -- <esc> to remove search highlighting
    map('n', '<esc>', ":nohls<cr><esc>")

    -- Redirect output of Ex command (XXX: nothing shows up in Ex until you start typing; using vimscript solves this)
    -- map({ 'n' }, "<leader>vr", ":put = execute('')<left><left>", { desc = "[R]edirect output of cmd (see also 'redir')" })
    vim.cmd [[nmap <leader>vr :put = execute('')<left><left>]]

    -- Enter terminal mode when terminal is open, and keybindigs
    vim.cmd [[
        autocmd TermOpen * startinsert
        tnoremap <C-w><C-w> <C-\><C-N><C-w><C-w>
        tnoremap <C-w>o <C-\><C-N><C-w>oi
        tnoremap <C-w>h <C-\><C-N><C-w>h
        tnoremap <C-w>j <C-\><C-N><C-w>j
        tnoremap <C-w>k <C-\><C-N><C-w>k
        tnoremap <C-w>l <C-\><C-N><C-w>l
    ]]

    -- list loaded modules
    -- map({ 'n' }, "<leader>vL", function() vim.notify(vim.inspect(package.loaded)) end, { desc = "[L]ist loaded modules" })

    -- Reuse terminal buffer or start a new one
    local function reuse_or_start_terminal()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_option(bufnr, 'buflisted') then
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if string.sub(bufname, 1, 7) == 'term://' and vim.fn.bufwinnr(bufnr) == -1 then
                    vim.cmd('sbuffer ' .. bufnr)
                    return
                end
            end
        end
    end

    -- python keybindings
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(args)
            local map = function(lhs, rhs, desc)
                vim.keymap.set('n', lhs, rhs, { buffer = args.buf, desc = desc })
            end
            map("<leader>vi", "<cmd>% !tidy-imports --replace-star-imports -r -p --quiet --black<cr>", "Add missing imports and sort")
            map("<leader>vP", "<cmd>update<cr><cmd>exec '!python3' shellescape(@%, 1)<cr>", "Run")
            -- Reuse terminal running ipython or start a new one
            vim.api.nvim_create_user_command('Ipython',
                function(opts)
                    reuse_or_start_terminal()
                    vim.cmd [[split | term ipython3 --profile=leetcode]]
                end, {})
            map("<leader>vp", "<cmd>Ipython<cr>", "iPython")
        end
    })

    -- cpp keybindings
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "cpp",
        callback = function(args)
            local map = function(lhs, rhs, desc)
                vim.keymap.set('n', lhs, rhs, { buffer = args.buf, desc = desc })
            end
            vim.api.nvim_create_user_command('ClangRepl',
                function(opts)
                    reuse_or_start_terminal()
                    vim.cmd [[split | term clang-repl --Xcc=-include"$HOME/.clang-repl-incl.h" --Xcc=-std=c++23 ]]
                end, {})
            map("<leader>vc", "<cmd>ClangRepl<cr>", "clang-repl")
        end
    })

    -- (:h emacs-keys) For Emacs-style editing on the command-line:
    vim.cmd [[
        " start of line
        :cnoremap <C-A>		<Home>
        " back one character
        :cnoremap <C-B>		<Left>
        " delete character under cursor
        :cnoremap <C-D>		<Del>
        " end of line
        :cnoremap <C-E>		<End>
        " forward one character
        :cnoremap <C-F>		<Right>
        " recall newer command-line
        :cnoremap <C-N>		<Down>
        " recall previous (older) command-line
        :cnoremap <C-P>		<Up>
        " back one word
        :cnoremap <Esc><C-B>	<S-Left>
        "   use Alt-B
        :cnoremap â	<S-Left>
        " forward one word
        :cnoremap <Esc><C-F>	<S-Right>
        "   use Alt-F
        :cnoremap æ	<S-Right>
    ]]
end


-- Toggle Options
do
    local toggle_opt = function(option)
        vim.opt_local[option] = not vim.opt_local[option]:get()
    end
    local map = vim.keymap.set
    map("n", "<leader>vs", function() toggle_opt("spell") end, { desc = "Toggle Spelling" })
end


-- Create autocommands
do
    local group = vim.api.nvim_create_augroup('MiscAutoCommands', { clear = true })

    -- Highlight on yank
    -- See `:help vim.highlight.on_yank()`
    vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
            vim.highlight.on_yank({ timeout = 400 })
        end,
        group = group,
        pattern = '*',
    })

    -- go to last cursor loc when opening a buffer
    vim.api.nvim_create_autocmd(
    "BufReadPost",
    { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
    )

    -- Check if we need to reload the file when it changed
    vim.api.nvim_create_autocmd("FocusGained", {
        command = [[:checktime]],
        group = group,
    })

    -- windows to close on 'q'
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "qf" },
        callback = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end,
    })

    -- -- don't auto comment new line
    -- vim.api.nvim_create_autocmd("BufEnter", {
    --     group = group,
    --     command = [[set formatoptions-=cro]]
    -- })

    -- create directories when needed, when saving a file
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        command = [[call mkdir(expand('<afile>:p:h'), 'p')]],
    })

    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
        pattern = { "[^l]*" },  -- Matches non-location list commands (e.g. :grep)
        callback = function()
            vim.cmd("cwindow")
        end,
    })

    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
        pattern = { "l*" },  -- Matches location list commands (e.g. :lgrep)
        callback = function()
            vim.cmd("lwindow")
        end,
    })

end


-- Firenvim
    -- https://www.reddit.com/r/neovim/comments/1b9nyt5/has_anyone_successfully_embedded_nvim_in_leetcode/
    -- When chrome/firefox starts Neovim, Firenvim sets the variable g:started_by_firenvim
if vim.g.started_by_firenvim then
    -- vim.o.guifont = 'FiraCode Nerd Font:h24'
    -- vim.o.guifont = 'FiraCode Nerd Font:h22'
    -- vim.o.guifont = 'FiraCode Nerd Font:h20'
    vim.o.guifont = 'Fira Code:h22'
    vim.cmd [[
        set background=light
        " https://github.com/glacambre/firenvim/issues/366
        nnoremap <D-v> "+p
        inoremap <D-v> <C-r>+
        cnoremap <D-v> <C-r>+
        set linespace=0 laststatus=0
        " for leetcode/nvim cmdheight should be >=2, otherwise it pauses for 'press enter...' message
        set cmdheight=2
        " NOTE: save 3 lines at the bottom by not printing full name of buffer
        " Set 'shortmess' and 'cmdheight' such that full name of buffer is printed
        " set shortmess-=t shortmess-=F cmdheight=3
    ]]

    -- pythondoc
    -- do
    --     if vim.fn.exists('g:loaded_pythondoc') then
    --         vim.api.nvim_create_autocmd({ "VimEnter" }, {
    --             callback = function(args)
    --                 vim.fn['PythondocExpandHH']()
    --             end
    --         })
    --     end
    -- end

    -- devdocs
    do
        if vim.fn.exists('g:loaded_devdocs') then
            vim.api.nvim_create_autocmd({ "VimEnter" }, {
                callback = function(args)
                    vim.fn['DevdocsExpandDD']()
                end
            })
        end
    end

    -- ATTENTION: Anytime you make change here, run `:call firenvim#install(0)` in nvim

    -- ATTENTION: Following is set in Chrome browser itself (only leetcode and colab.google allowed)
    -- NOTE: Even though takeover=never, you can type <command-E> to invoke nvim
    vim.g.firenvim_config = {
        localSettings = {
            ['.*'] = { takeover = 'never', priority = 0, cmdline = 'neovim' },
            -- ['.*leetcode.*'] = { takeover = 'always', priority = 1, cmdline = 'neovim' },
            -- ['.*github.*'] = { takeover = 'always', priority = 1, cmdline = 'neovim' },
            -- ['.*google.*'] = { takeover = 'never', priority = 1, cmdline = 'neovim' },
            -- ['.*colab.*'] = { takeover = 'always', priority = 2, cmdline = 'neovim' }, -- colab.research.google
        }
    }

    local grp = vim.api.nvim_create_augroup("FireNvim", { clear = true })

    local function insert_header()
        local line = vim.fn.getline(1);
        local hdr = '//--------------------'
        if line ~= hdr then
            local txt = {
                hdr,
                'typedef signed long long ll;',
                'typedef vector<int> vi;',
                'typedef vector<vector<int>> vii;',
                'typedef pair<int,int> pi;',
                'typedef vector<string> vs;',
                '#define F first',
                '#define S second',
                '#define PB push_back',
                -- '#define FOR(i,a,b) for (int i = (a); i < (b); i++)',
                -- '#define FOR_(i,a,b) for (int i = (a); i >= (b); i--)',
                -- '#define FORR(x,arr) for(auto& x:arr)',
                -- '#define ITR(x,c) for(__typeof(c.begin()) x=c.begin();x!=c.end();x++)',
                '#define _PR(x,T) ranges::for_each((x), [](const T& n) {cout << n;});cout<<endl;',
                hdr,
            }
            vim.fn.append(0, txt)
        end
    end

    vim.api.nvim_create_autocmd('BufReadPost', {
        group = grp,
        pattern = {'*leetcode.com_*.txt', '*colab*.txt'},  -- colab.research.google
        callback = function()
            vim.cmd 'syntax enable'
            -- vim.bo.filetype = 'python'
            -- vim.cmd 'set syntax=python'
            -- vim.bo.filetype = 'cpp'
            vim.cmd 'set ft=cpp'
            vim.cmd 'set syntax=cpp'
            -- vim.cmd 'set signcolumn=no'
            -- insert_header()
            vim.fn.histadd('cmd', [[s/\vi(\W)/x\1/g]]) -- 'i' -> 'x' in 'for(int i=0;i< ...)'
        end,
    })

    -- https://github.com/glacambre/firenvim/issues/1619
    local stretch_nvim_only_not_textarea = false

    if stretch_nvim_only_not_textarea then
        local max_height = 25
        vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
            group = grp,
            callback = function(ev)
                local height = vim.api.nvim_win_text_height(0, {}).all
                if height > vim.o.lines and height < max_height then
                    vim.o.lines = height
                    vim.cmd "norm! zb"
                end
            end
        })
    else
        -- NOTE: Window is jumpy; It resizes on every keystroke.
        vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
            group = grp,
            callback = function(e)
                -- throttle write to prevent hiccup during 'paste'
                if vim.g.timer_started == true then
                    return
                end
                vim.g.timer_started = true
                vim.fn.timer_start(200, function()
                    vim.g.timer_started = false
                    -- vim.cmd "silent write | norm! zb"
                    vim.cmd "silent update"
                end)
            end
        })
    end

    vim.api.nvim_create_autocmd('WinScrolled', {
        group = grp,
        pattern = '*',
        callback = function()
            local bufname = vim.fn.bufname('%')
            if string.find(bufname, 'colab') then
                vim.o.columns = 120
            end
        end
    })

    -- Prepend with 'silent!' to ignore errors when colorscheme is not yet installed.
    -- light colorschemes: zellner, lunaperche, vim, shine, delek
    vim.cmd [[silent! colorscheme modus]]
else
    -- vim.cmd 'silent! colorscheme patana'
end

-- text utilities
    -- Toggle current word
do
    local text_toggle = function()
        local toggles = {
            ['true'] = 'false', ['false'] = 'true', True = 'False', False = 'True', TRUE = 'FALSE', FALSE = 'TRUE',
            yes = 'no', no = 'yes', Yes = 'No', No = 'Yes', YES = 'NO', NO = 'YES',
            on = 'off', off = 'on', On = 'Off', Off = 'On', ON = 'OFF', OFF = 'ON',
            open = 'close', close = 'open', Open = 'Close', Close = 'Open',
            dark = 'light', light = 'dark',
            width = 'height', height = 'width',
            first = 'last', last = 'first',
            left = 'right', right = 'left',
            top = 'bottom', bottom = 'top',
        }
        local word = vim.fn.expand("<cword>")
        if toggles[word] ~= nil then
            vim.cmd('normal! \"_ciw' .. toggles[word])
        end
    end
    vim.keymap.set('n', '<Leader>vt', function() text_toggle() end, {noremap = true, silent = true})
end


-- nvim-cmp
do
    local cmp = require'cmp'

    local has_words_before = function()
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
            -- { name = 'abbrev', max_item_count = 15, trigger_characters = {'('} },
            { name = 'abbrev', max_item_count = 15 },
            { name = 'dict', max_item_count = 20 },
            -- { name = 'nvim_lsp' },  -- does not work with leetcode
            -- { name = 'vsnip', max_item_count = 15 },
        }),
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = vim_item.kind:sub(1, 1)
                vim_item.menu = ''
                return vim_item
            end
        },
    })

    -- configure clangd
    -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- require('lspconfig').clangd.setup {
    --     capabilities = capabilities,
    -- }

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

    local function string_split(str, pat)
        local split = {}
        for s in str:gmatch(pat) do
            table.insert(split, s)
        end
        return split
    end

    -- source abbreviations
    local abbr_source = function()
        local source = {}

        source.new = function()
            local self = setmetatable({}, { __index = source })
            return self
        end

        source._get_abbrevs = function()
            local lines = vim.fn.execute('ia', 'silent!')
            if string.find(lines, vim.fn.gettext('No abbreviation found')) then
                return nil
            end
            local abbrs = {}
            for _, line in ipairs(string_split(lines, "[^\r\n]+")) do  -- \r is CR (ascii 13), \n is LF (ascii 10)
                _, _, abbr, expn = string.find(line, "^i%s+(%S+)%s+(.+)")
                if abbr ~= nil then
                    table.insert(abbrs, { label = abbr, dup = 0, kind = cmp.lsp.CompletionItemKind.Snippet })
                end
            end
            return abbrs
        end

        source.get_keyword_pattern = function(self, params)
            return [[\k\+]]  -- \k is better than \S; triggers after '(' in foo(abbrev
        end

        source.complete = function(self, params, callback)
            local items = source._get_abbrevs()
            callback({ items = items, isIncomplete = true })
        end
        return source
    end

    cmp.register_source("abbrev", abbr_source().new())

    -- source dictionary
    local dict_source = function(dirpath)
        local source = {}

        source.new = function()
            local self = setmetatable({}, { __index = source })
            return self
        end

        dict_items = nil  -- global var
        source._get_words = function()
            if dict_items ~= nil then
                return dict_items
            end
            dict_items = {}
            local fpath = vim.fn.expand(dirpath)
            local file = io.open(fpath, "r")
            if file then
                for line in io.lines(fpath) do
                    table.insert(dict_items, { label = line, dup = 0, kind = cmp.lsp.CompletionItemKind.Keyword })
                end
                file:close()
            end
            return dict_items
        end

        source.get_keyword_pattern = function(self, params)
            return [[\k\+]]
        end

        source.complete = function(self, params, callback)
            local items = source._get_words()
            callback({ items = items, isIncomplete = true })
        end
        return source
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(args)
            cmp.register_source("dict", dict_source('$HOME/.vim/data/python.dict').new())
        end
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "cpp",
        callback = function(args)
            cmp.register_source("dict", dict_source('$HOME/.vim/data/cpp.dict').new())
        end
    })
end

-- fFtT
local fFtT_id = 0
do
    local function highlight_clear()
        if fFtT_id > 0 then
            vim.fn.matchdelete(fFtT_id)
            vim.cmd 'redraw'
            fFtT_id = 0
        end
        return ''
    end

    vim.api.nvim_create_autocmd({ 'SafeState', 'CursorMoved', 'ModeChanged', 'TextChanged', 'WinEnter', 'WinLeave', 'CmdWinLeave' }, {
        group = vim.api.nvim_create_augroup('fFtTHighlight', { clear = true }),
        pattern = '*',
        callback = function(args)
            highlight_clear()
        end
    })

    -- Gather locations of characters to be dimmed.
    local function highlight_chars(s)
        local _, lnum, col, _ = unpack(vim.fn.getpos('.'))
        local line = vim.fn.getline('.')
        if line == '' then
            return ''
        end
        -- Extended ASCII characters can pose a challenge if we simply iterate over
        -- bytes. It is preferable to let Vim split the line by characters for more
        -- accurate handling.
        local found = {}
        for _, ch in ipairs(vim.fn.split(line, '\\zs')) do
            if not found[ch] then
                found[ch] = true
            end
        end
        local start = col - 2
        local reverse = true
        if s == 'f' or s == 't' then
            start = col
            reverse = false
        end
        local locations = {}
        local freq = {}
        local maxloc = math.max(100, vim.o.lines * vim.o.columns)
        for ch, _ in pairs(found) do
            local loc = reverse and vim.fn.strridx(line, ch, start) or vim.fn.stridx(line, ch, start)
            while loc ~= -1 do
                if freq[ch] then
                    freq[ch] = freq[ch] + 1
                else
                    freq[ch] = 1
                end
                if freq[ch] ~= vim.v.count1 then
                    if freq[ch] > maxloc then
                        -- For long lines, do not search beyond what is visible
                        break
                    end
                    table.insert(locations, {lnum, loc + 1})
                end
                loc = reverse and vim.fn.strridx(line, ch, loc - 1) or vim.fn.stridx(line, ch, loc + 1)
            end
        end
        if next(locations) ~= nil then
            if fFtT_id > 0 then
                matchdelete(fFtT_id)
            end
            fFtT_id = vim.fn.matchaddpos('NonText', locations, 1001)
            vim.cmd 'redraw'
        end
        return ''
    end

    local map = vim.keymap.set
    for _, cmd in ipairs({'f', 'F', 't', 'T'}) do
        local lhs = '<Plug>(fFtT-' .. cmd .. ')'
        map({'n', 'x', 'o'}, lhs, function() highlight_chars(cmd) end, {noremap = true, silent = true, expr = true})
        map({'n', 'x', 'o'}, cmd, lhs .. cmd, { noremap = true, silent = true })
    end
end

-- easyjump
do
    local alpha = 'asdfgwercvhjkluiopynmbtqxz'
    local letters = alpha .. vim.fn.toupper(alpha) .. '0123456789'
    local labels = letters
    local locations = {}
    vim.cmd 'highlight! link Conceal Search'

    -- get all line numbers in the visible area of the window ordered by distance from cursor
    local function window_line_nrs()
        local lstart = math.max(1, vim.fn.line('w0'))
        -- line('w$') does not include a long line (broken into many lines) that is only partly visible
        -- local lend =  math.min(vim.fn.line('w$') + 1, vim.fn.line('$'))
        local lend = math.min(vim.fn.line('w$'), vim.fn.line('$'))
        local _, curline, curcol = unpack(vim.fn.getcurpos())
        local lnums = {curline}
        for dist = 1, (lend - lstart) do
            if curline + dist <= lend then
                table.insert(lnums, curline + dist)
            end
            if curline - dist >= lstart then
                table.insert(lnums, curline - dist)
            end
        end
        return lnums
    end

    local function gather_locations(ctx)
        locations = {}
        local _, curline, curcol = unpack(vim.fn.getcurpos())
        for _, lnum in ipairs(window_line_nrs()) do
            if vim.fn.foldclosed(lnum) == -1 then
                local line = vim.fn.getline(lnum)
                local col = vim.fn.stridx(line, ctx)
                while col ~= -1 do
                    col = col + 1  -- column numbers start from 1
                    if ctx == ' ' and next(locations) ~= nil and locations[#locations][1] == lnum
                        and locations[#locations][2] == col - 1 then
                        locations[#locations][2] = col  -- one target per cluster of adjacent spaces
                    elseif lnum ~= curline or col ~= curcol then  -- no target on cursor position
                        table.insert(locations, {lnum, col})
                    end
                    col = vim.fn.stridx(line, ctx, col)
                end
            end
        end
    end

    local function show_locations(group)
        vim.fn.clearmatches()
        local ntags = labels:len()
        for idx = 1, math.min(ntags, #locations - (group - 1) * ntags) do
            local lnum, col = unpack(locations[idx + (group - 1) * ntags])
            -- print(labels, idx, lnum, col, labels:sub(idx, idx))
            vim.fn.matchaddpos('Conceal', {{lnum, col}}, 1001, -1, {conceal = labels:sub(idx, idx)})
        end
        vim.cmd 'redraw'
    end

    local function jump_to(tgt, group)
        local tagidx = vim.fn.stridx(labels, tgt) + 1
        local locidx = tagidx + (group - 1) * labels:len()
        if tagidx > 0 and locidx <= #locations then
            local loc = locations[locidx]
            vim.cmd [[ normal! m' ]]
            vim.fn.cursor(unpack(loc))
        end
    end

    local function do_jump()
        local function do_jump_protected()
            local ch = vim.fn.getcharstr()
            gather_locations(ch)
            if next(locations) == nil then
                return
            end
            local ngroups = math.floor(#locations / labels:len()) + 1
            local group = 1
            show_locations(group)
            ch = vim.fn.getcharstr()

            while ngroups > 1 and (ch == ';' or ch == ',') do
                if ch == ';' then
                    group = group + 1
                    if group > ngroups then
                        group = 1
                    end
                else
                    group = group - 1
                    if group == 0 then
                        group = ngroups
                    end
                end
                show_locations(group)
                ch = vim.fn.getcharstr()
            end
            jump_to(ch, group)
        end
        local saved_cole = vim.o.conceallevel
        local saved_cocu = vim.o.concealcursor
        vim.o.conceallevel = 2
        vim.o.concealcursor = 'nv'
        pcall(do_jump_protected)
        vim.fn.clearmatches()
        vim.o.conceallevel = saved_cole
        vim.o.concealcursor = saved_cocu
    end

    local function do_vjump()
        do_jump()
        vmd.cmd [[normal! m'gv``]]
    end

    local map = vim.keymap.set
    map({'n', 'o'}, '<Plug>EasyjumpJump;', function() vim.cmd('norm <c-u>'); do_jump(); vim.cmd 'norm <cr>' end, {noremap = true, silent = true})
    map('v', '<Plug>EasyjumpJump;', function() vim.cmd('norm <c-u>'); do_vjump(); vim.cmd 'norm <cr>' end, {noremap = true, silent = true})
    map({'n', 'o', 'v'}, 's', '<Plug>EasyjumpJump;')
end

--nvim:ts=4:et:sw=4:
