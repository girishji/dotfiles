--[[

github: vim-lua/kickstart.nvim and LazyVim
:checkhealth lazy

<space><bs> reveals more commands in which-key

To clean out old installations:
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

treesitter-textobjects has keymaps defined for for/while loop, if statement, function, class, etc.

Do not install mason. It installss arm and x86 binaries into a single directory

Telescope default keymaps:
<C-x>	Go to file selection as a split
<C-v>	Go to file selection as a vsplit
<C-t>	Go to a file in a new tab
<C-q>	Send all items not filtered to quickfixlist (qflist)
<M-q>	Send all selected items to qflist

--]]
--
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Map backspace to leader without overriding <space> as leader
vim.cmd([[map <BS> <Leader>]])

-- XXX comment this as needed
-- vim.lsp.set_log_level('debug')

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE:
--  1) Call the setup() function of plugin within 'lazy' setup implicitly:
--     'path/pluginname', opts = {}
--      You can configure plugins further by using the `config` key.
--  2) As an alternative do the following later to setup plugin:
--    require('pkgname').setup({...})
require('lazy').setup({
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      -- { 'j-hui/fidget.nvim', opts = { debug = { strict = true, } } },

      -- Provide function signatures for lua development
      'folke/neodev.nvim',
    },
  },

  -- {
  --   'glacambre/firenvim',

  --   -- Lazy load firenvim
  --   -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
  --   lazy = not vim.g.started_by_firenvim,
  --   build = function()
  --     vim.fn["firenvim#install"](0)
  --   end
  -- },

  {
    -- formatting and linting
    'jose-elias-alvarez/null-ls.nvim',
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',                  -- buffer completions
      'hrsh7th/cmp-path',                    -- path completions
      'hrsh7th/cmp-nvim-lua',                -- for lua api
      'hrsh7th/cmp-nvim-lsp-signature-help', -- function signature help
      -- 'saadparwaiz1/cmp_luasnip',            -- snippet completions
      -- 'L3MON4D3/LuaSnip',                    --snippet engine
      'rafamadriz/friendly-snippets',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      -- 'octaltree/cmp-look',
    },
  },

  {
    -- cmdline completions
    -- NOTE: ctrl-e will dismiss the popup
    'hrsh7th/cmp-cmdline',
    pendencies = {
      'hrsh7th/cmp-buffer', -- buffer completions
    },
    config = function()
      -- `/` cmdline setup.
      local cmp = require('cmp')
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer', max_item_count = 20 }
        }
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          {
            name = 'cmdline',
            max_item_count = 10,
            option = { ignore_cmds = { 'Man', '!' } }
          }
        })
      })
    end
  },

  -- Snippet
  -- {
  --   'L3MON4D3/LuaSnip',
  --   dependencies = {
  --     'rafamadriz/friendly-snippets',
  --   },
  --   config = function()
  --     require('luasnip.loaders.from_vscode').lazy_load({ include = { 'python', 'java', 'c', 'cpp' } })
  --     -- https://github.com/Allaman/nvim/blob/main/lua/core/plugins/luasnip.lua
  --     require('luasnip.loaders.from_lua').load({ paths = os.getenv('HOME') .. '/.config/nvim/snippets/' })
  --     local luasnip = require('luasnip')
  --     -- [[ Setup luasnip ]]
  --     luasnip.setup({
  --       history = false,                                   -- if you hop back into snippet later
  --       update_events = { "TextChanged", "TextChangedI" }, -- dynamic snippets update as you type
  --       -- enable_autosnippets = true,                        -- insert snippet when new file is created
  --     })
  --     -- ([l]ist) cycle through choices for 'choice nodes'
  --     vim.keymap.set({ 'i', 's' }, '<c-l>', function()
  --       if luasnip.choice_active() then
  --         luasnip.change_choice(1)
  --       end
  --     end)
  --     -- vim.keymap.set('n', '<leader>cl', function() load_luasnippets() end, { desc = 'Reload lua snippets' })
  --     vim.keymap.set('n', '<leader>cl', function()
  --       require("luasnip.loaders").edit_snippet_files({
  --         format = function(file, source_name) -- only present luasnip files
  --           return source_name == "lua" and file or nil
  --         end
  --       })
  --     end, { desc = 'Edit [l]ua snippets' })
  --   end,
  -- },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {
      plugins = {
        -- marks = false,
        -- registers = false,
      },
      triggers_nowait = { -- https://github.com/folke/which-key.nvim/issues/152
        "z=",             -- spelling
      },
      window = {
        border = "single", -- none, single, double, shadow
      },
      layout = {
        height = { min = 4, max = 30 }, -- min and max height of the columns
      },
    },
  },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    -- See `:help gitsigns.txt`
    opts = {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '' },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next git Hunk")
        map("n", "[h", gs.prev_hunk, "Prev git Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>gd", gs.diffthis, "Diff This")
        map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  {
    -- Theme
    "girishji/declutter.nvim",
    priority = 1000,
    config = function()
      require 'declutter'.setup({ theme = 'minimal' })
      vim.cmd.colorscheme 'declutter'
      -- vim.o.termguicolors = true
    end,
  },

  {
    "girishji/bufline.vim",
    opts = { showbufnr = true, highlight = true }
  },

  -- {
  --   -- Add indentation guides even on blank lines
  --   'lukas-reineke/indent-blankline.nvim',
  --   -- See `:help indent_blankline.txt`
  --   opts = {
  --     -- https://www.compart.com/en/unicode/search?q=vertical#characters
  --     char = '⋮', -- '│' -- char = '┊', char = '▏',|⏐│ |❘ ⁞❚ ⋮┊
  --     show_trailing_blankline_indent = false,
  --     char_highlight_list = {
  --       "IndentBlanklineIndent1",
  --     },
  --   },
  -- },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Code overview
  -- {
  --   'stevearc/aerial.nvim',
  --   opts = {},
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  -- },

  -- autopairs
  -- { 'windwp/nvim-autopairs',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/playground', -- For viewing treesitter AST
      'girishji/declutter.nvim',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  {
    -- nvim-jdtls
    'mfussenegger/nvim-jdtls'
  },

  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
  },

  -- NOTE: This will add plugins from lua/plugins folder
  -- { import = 'plugins' },
}, {
  ui = {
    border = 'single',
    icons = {
      cmd = "* ",
      config = "*",
      event = "*",
      ft = "* ",
      init = "* ",
      import = "* ",
      keys = "* ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = "* ",
      runtime = "* ",
      source = "* ",
      start = "*",
      task = "✔ ",
    }
  }
})

-- check if plugin is installed
local function has_plugin(plugin)
  return package.loaded[plugin]
  -- NOTE: can also be done as follows
  -- return require("lazy.core.config").plugins[plugin] ~= nil
end

-- [[ Setting options ]]
-- See `:help vim.o`
do
  vim.o.hlsearch = true -- Set highlight on search
  vim.wo.number = true  -- Make line numbers default
  vim.wo.relativenumber = true
  -- vim.o.mouse = 'a' -- Enable mouse mode
  vim.o.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim. See `:help 'clipboard'`
  vim.o.breakindent = true        -- Enable break indent
  vim.o.undofile = false          -- Save undo history (XXX: better to not go back too deep when typing 'u')
  vim.o.ignorecase = true         -- Case insensitive searching UNLESS /C or capital in search
  vim.o.smartcase = true
  -- vim.o.winbar = "%=%m %F"  --  Winbar
  vim.o.laststatus = 3      -- one statusbar for all split windows
  vim.wo.signcolumn = 'yes' -- Keep signcolumn on by default
  -- Decrease update time
  vim.o.updatetime = 250
  vim.o.timeout = true
  vim.o.timeoutlen = 300

  vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
  vim.o.shiftwidth = 2
  vim.o.expandtab = true
  vim.o.scrolloff = 4
  vim.o.sidescrolloff = 4
  vim.o.shada = "!,%,'100,<50,s10,h" -- '%' to store the buffers (invoke nvim without filename)
end

-- Ex commands

vim.api.nvim_create_user_command(
  'Reload',
  function(opts)
    if package.loaded[opts.args] then
      package.loaded[opts.args] = nil
    end
    require(opts.args)
  end,
  { nargs = 1 })

do
  local buflisted = function(pred)
    local buflist = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buflist) do
      if vim.bo[buf].filetype == 'help' then
        vim.bo[buf].buflisted = pred
      end
    end
  end
  vim.api.nvim_create_user_command(
    'ShowHelpBuffers',
    function() buflisted(true) end,
    { nargs = 0 })
  vim.api.nvim_create_user_command(
    'HideHelpBuffers',
    function() buflisted(false) end,
    { nargs = 0 })
end


-- [[ Abbreviations ]]
-- To avoid the abbreviation in Insert mode: Type CTRL-V before the character
-- that would trigger the abbreviation.  E.g. CTRL-V <Space>.  Or type part of
-- the abbreviation, exit insert mode with <Esc>, re-enter insert mode with "a"
-- and type the rest.
--
-- To avoid the abbreviation in Command-line mode: Type CTRL-V twice somewhere in
-- the abbreviation to avoid it to be replaced.
--
-- :ab - to list all abbreviations
vim.cmd [[
  " Consume the space typed after an abbreviation (:h abbreviation)
   func Eatchar(pat)
      let c = nr2char(getchar(0))
      return (c =~ a:pat) ? '' : c
   endfunc

	augroup vimrc
	  autocmd! |" Remove all vimrc autocommands
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

  -- Keymaps for better default experience
  -- See `:help vim.keymap.set()`
  map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  map({ 'n', 'v' }, 'gm', 'gM', { silent = true, desc = "Jump to middle of line" })

  -- g* selects foo in foobar while * selects <foo>, <> is word boundary. make * behave like g*
  map('n', '*', 'g*', { silent = true })
  map('n', '#', 'g#', { silent = true })

  -- Write and quit
  map({ 'n', 'v' }, '<leader>w', '<cmd>write<cr>', { desc = '[W]rite buffer' })
  map({ 'n', 'v' }, '<leader>q', '<cmd>qa<cr>', { desc = '[Q]uit all' })
  map({ 'n', 'v' }, '<leader>Q', '<cmd>q!<cr>', { desc = '[Q]uit without saving' })

  -- Remap for dealing with word wrap
  map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- For better buffer navigation
  map('n', '[[', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
  map('n', ']]', '<cmd>bnext<cr>', { desc = 'Next buffer' })
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

  -- Move Lines
  map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
  map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
  map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
  map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
  map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
  map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

  -- suspend
  map({ 'v', 'n' }, "<leader>z", "<cmd>sus<cr>", { desc = "Suspend nvim" })

  -- better indenting
  map("v", "<", "<gv")
  map("v", ">", ">gv")

  -- lazy
  map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

  -- windows (see C-w keymaps)
  map("n", "<leader>o", "<C-W>w", { desc = "Other window" })
  map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
  map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })
  require('which-key').register({ ['<c-w>c'] = "Close window (|:close|)" }, { mode = 'n' })

  -- gp reselect last modified chunk (including pasted)
  vim.cmd [[ nnoremap <expr> gp '`[' . getregtype()[0] . '`]' ]]
  require('which-key').register({ ['gp'] = "Visually select pasted text" }, { mode = 'n' })

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
  map({ 'n' }, "<leader>vb", "<cmd>ls<cr>", { desc = "Show (listed) [b]uffers (:ls)" }) -- :buffers same as :ls
  map({ 'n' }, "<leader>vB", "<cmd>ls!<cr>", { desc = "Show all [b]uffers (:ls!)" })    -- :buffers same as :ls
  map({ 'n' }, "<leader>vl", "<cmd>set buflisted<cr>", { desc = "[L]ist current buffer in buffer list" })
  map({ 'n' }, "<leader>vu", "<cmd>set nobuflisted<cr>", { desc = "[U]nlist current buffer" })
  -- Print full path of file in current buffer
  map({ 'n', 'v' }, "<leader>vp", function() print(vim.fn.expand('%:p')) end,
    { desc = "Show full [p]ath of current buffer" })
  -- list loaded modules
  map({ 'n' }, "<leader>vL", function() vim.notify(vim.inspect(package.loaded)) end, { desc = "[L]ist loaded modules" })
  if vim.fn.has("nvim-0.9.0") == 1 then
    -- inspect highlight groups under cursor
    map({ "n" }, "<leader>vi", vim.show_pos, { desc = "Inspect treesitter highlights (etc.) under cursor" })
  end

  -- undo tree commands
  -- https://vimhelp.org/usr_32.txt.html#usr_32.txt
  map({ 'n' }, "<leader>uu", "<cmd>undolist<cr>", { desc = "[U]ndolist (:undo {number}, g+, g-)" })
  map({ 'n' }, "<leader>ue", "<cmd>earlier ", { desc = "Undo [E]arlier {count}{s|m|h|d}" })
  map({ 'n' }, "<leader>uL", "<cmd>later ", { desc = "Undo [L]ater {count}{s|m|h|d}" })


  if has_plugin('neogen') then
    map({ 'n' }, "<leader>cA", "<cmd>Neogen<CR>", { desc = "[A]nnotation" })
  end

  if has_plugin('declutter') then
    map({ 'n' }, "<leader>uc", "<cmd>DCToggleBrightComments<cr>", { desc = "Toggle Bright Comment Text" })
  end

  if has_plugin('nvim-treesitter') then
    -- treesitter playground
    map({ 'n' }, "<leader>cP", "<cmd>TSPlaygroundToggle<cr>", { desc = "Treesitter [P]layground" })
  end

  -- (LSP) Diagnostic keymaps
  map({ 'n' }, '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
  map({ 'n' }, ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
  map({ 'n' }, 'gl', vim.diagnostic.open_float, { desc = "Open [F]loating diagnostic message" })
  map({ 'n' }, '<leader>x', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
end


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
  nmap("n", "<leader>uf", '<cmd>FormatOnSaveToggle<cr>', { desc = "Toggle format on Save" })
  nmap("n", "<leader>us", function() toggle_opt("spell") end, { desc = "Toggle Spelling" })
  nmap("n", "<leader>uw", function() toggle_opt("wrap") end, { desc = "Toggle Word Wrap" })
  nmap("n", "<leader>ul", function()
    if vim.wo.relativenumber then
      vim.wo.relativenumber = false
      vim.wo.number = true
    elseif vim.wo.number then
      vim.wo.number = false
      vim.wo.relativenumber = false
    else -- enabling both will make cursor line show line number instead of 0
      vim.wo.relativenumber = true
      vim.wo.number = true
    end
  end, { desc = "Toggle Line Numbers" })
  nmap("n", "<leader>ud", toggle_diagnostics, { desc = "Toggle Diagnostics" })
  -- Toggle code overview window
  nmap('n', '<leader>uo', '<cmd>AerialToggle!<CR>', { desc = 'Toggle Code Overeview' })
end

-- [[ Create autocommands ]]
do
  local my_aucmd_group = vim.api.nvim_create_augroup('MyCommands', { clear = true })

  -- Save yank'ed text into numbered registers and rotate. By default vim
  -- stores yank into "0 (does not rotate) and stores deleted and changed text
  -- into "1 and rotates (:h "1). If deleted text is less than a line it is also
  -- stored in "- register (aka small delete register).

  vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    pattern = '*',
    callback = function()
      -- convert vim variable dictionary into a lua dict/table
      -- see :h lua-guide
      local vevent = vim.api.nvim_eval('v:event')
      -- this event is triggered for both yank and delete
      if vevent['regname'] == "" and vevent['operator'] == 'y' then
        for i = 8, 1, -1 do
          vim.fn.setreg(i + 1, vim.fn.getreg(i))
        end
        vim.fn.setreg(1, vevent['regcontents'])
      end
    end,
  })

  -- [[ cursorline only when not in insert mode ]]
  -- https://github.com/mhinz/vim-galore#smarter-cursorline
  vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter", "BufEnter" }, {
    pattern = '*',
    callback = function()
      vim.wo.cursorline = true
      -- if vim.bo.filetype ~= 'markdown' then
      --   vim.wo.cursorline = true
      -- end
    end,
    group = my_aucmd_group,
  })
  vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    command = [[set nocursorline]],
    pattern = '*',
    group = my_aucmd_group,
  })

  -- statusline
  local diag = function()
    local levels = { 'Error', 'Warn', 'Info', 'Hint' }
    local higroup = { "%5*E:", "%7*W:", "%6*I:", "%8*H:" } -- "%#User6#" is "%6*"
    local ret = ""
    for i, level in ipairs(levels) do
      local grp = higroup[i]
      local count = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
      if count ~= 0 then
        ret = ret .. " " .. grp .. count .. "%*"
      end
    end
    return ret
  end

  local gitinfo = function()
    ---@diagnostic disable-next-line: undefined-field
    if not package.loaded['gitsigns'] or not vim.b.gitsigns_status_dict
        ---@diagnostic disable-next-line: undefined-field
        or not vim.b.gitsigns_status_dict.head then
      return ''
    end
    local gitinfo = vim.b.gitsigns_status_dict
    local signs = { 'added', 'changed', 'removed' }
    local groups = { "%6*+", "%7*~", "%5*-", } -- "%#User6#" is "%6*"
    local ret = " (" .. gitinfo.head .. ")"
    for i, sign in ipairs(signs) do
      local grp = groups[i]
      if gitinfo and gitinfo[sign] and (gitinfo[sign] > 0) then
        ret = ret .. ' ' .. grp .. gitinfo[sign] .. "%*"
      end
    end
    return ret
  end

  local lineinfo = function()
    if vim.bo.filetype == "alpha" then
      return ""
    end
    return " %y %P %l:%c " -- percent linenum column
  end

  Statusline = {}

  Statusline.active = function()
    local diagstr = diag()
    diagstr = diagstr ~= '' and diagstr .. " |" or ''
    -- local gitstr = gitinfo()
    -- gitstr = gitstr ~= '' and gitstr .. " " or ''
    return table.concat {
      "%1*",
      diagstr,
      require('bufline').bufferstr(),
      "%=",
      gitinfo(),
      lineinfo(),
      "%*"
    }
  end

  Statusline.inactive = function()
    return " %F"
  end

  Statusline.short = function()
    return ""
  end

  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "BufAdd" }, {
    group = my_aucmd_group,
    pattern = "*",
    callback = function()
      vim.wo.statusline = "%!v:lua.Statusline.active()"
    end,
  })

  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = my_aucmd_group,
    pattern = "*",
    callback = function()
      vim.wo.statusline = "%!v:lua.Statusline.inactive()"
    end,
  })

  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FileType" }, {
    group = my_aucmd_group,
    pattern = "NvimTree",
    callback = function()
      vim.wo.statusline = "%!v:lua.Statusline.short()"
    end,
  })

  -- conceal fenced code delimiters and other delimiters
  -- vim.api.nvim_create_autocmd({ "BufEnter" }, {
  --   command = [[set conceallevel=1]],
  --   pattern = { '*.md' },
  --   group = my_aucmd_group,
  -- })

  -- [[ Highlight on yank ]]
  -- See `:help vim.highlight.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank({ timeout = 400 })
    end,
    group = my_aucmd_group,
    pattern = '*',
  })

  -- [[ go to last cursor loc when opening a buffer ]]
  vim.api.nvim_create_autocmd(
    "BufReadPost",
    { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
  )

  -- [[ Check if we need to reload the file when it changed ]]
  vim.api.nvim_create_autocmd("FocusGained", {
    command = [[:checktime]],
    group = my_aucmd_group,
  })

  -- [[ windows to close ]]
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {
      "help",
      "startuptime",
      "qf",
      "lspinfo",
      "vim",
      "fugitive",
      "git",
      "neotest-summary",
      "query",
      "neotest-output",
      "spectre_panel",
      "tsplayground",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
  })
  vim.api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })
  vim.api.nvim_create_autocmd("FileType", { pattern = "cheat", command = [[nnoremap <buffer><silent> q :bdelete!<CR>]] })

  -- [[ don't auto comment new line ]]
  vim.api.nvim_create_autocmd("BufEnter", {
    group = my_aucmd_group,
    command = [[set formatoptions-=cro]]
  })

  -- [[ create directories when needed, when saving a file ]]
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = my_aucmd_group,
    command = [[call mkdir(expand('<afile>:p:h'), 'p')]],
  })

  -- [[ vim help files: generate tags when saved ]]
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = 'doc/*.txt',
    group = my_aucmd_group,
    command = [[helptags <afile>:p:h]],
  })
end


-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- telescope keymaps
local telescope_keymaps = function()
  -- See `:help telescope.builtin`
  local nmap = function(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { desc = desc })
  end

  nmap('<leader>ff', require('telescope.builtin').oldfiles, 'Find recently opened [f]iles')
  nmap('<leader>fb', require('telescope.builtin').buffers, 'Find existing [b]uffers')
  nmap('<leader><BS>', function()
    require('telescope.builtin').current_buffer_fuzzy_find({
      layout_strategy = 'vertical',
      layout_config = { width = 0.9, height = 0.9, preview_cutoff = 1 }
    })
  end, '[/] Fuzzy search in cur buf')
  nmap('<leader><space>', function()
    require('telescope.builtin').find_files({
      shorten_path = true, -- /x/y/z/filename
      -- cwd = "~/.config/nvim",
      layout_config = { width = 0.9, preview_width = 0.6 },
    })
  end, '[ ] Find Files')
  nmap('<leader>fh',
    function()
      -- require('telescope.builtin').help_tags(require('telescope.themes').get_dropdown({
      --   layout_config = { width = 0.9 } }))
      require('telescope.builtin').help_tags({
        layout_strategy = 'vertical',
        layout_config = { width = 0.9, height = 0.9, preview_cutoff = 1 }
      })
    end,
    'Search [H]elp')
  nmap('<leader>fw', require('telescope.builtin').grep_string, 'Search for [W]ord under cursor in CWD')
  nmap('<leader>fg', require('telescope.builtin').live_grep, 'Live [G]rep in CWD')
  nmap('<leader>fd', require('telescope.builtin').diagnostics, 'Search [D]iagnostics')
  nmap('<leader>fc', require('telescope.builtin').quickfix, 'Search quickfix list')
  nmap('<leader>fC', require('telescope.builtin').quickfixhistory, 'Search quickfix lists in history')
  nmap('<leader>fj', require('telescope.builtin').jumplist, 'Search [j]umplist')
  nmap('<leader>fe', '<cmd>Telescope commands<cr>', 'Search Vim [E]x Commands')
  nmap('<leader>fa', '<cmd>Telescope autocommands<cr>', 'Search Vim [A]utocommands')
  nmap('<leader>fH', '<cmd>Telescope highlights<cr>', 'Search [H]ighlight Groups')
  nmap('<leader>fk', '<cmd>Telescope keymaps<cr>', 'Search [K]ey Maps')
  nmap('<leader>ft', '<cmd>Telescope treesitter<cr>', 'Search [T]reesitter nodes')
  nmap('<leader>fM', '<cmd>Telescope man_pages<cr>', 'Search [M]an Pages')
  nmap('<leader>fs', require('telescope.builtin').lsp_document_symbols, 'Search Document [s]ymbols')
  nmap('<leader>fS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Search Workspace [S]ymbols')
  nmap('<leader>fp', require('telescope.builtin').builtin, 'Lists Built-in [p]ickers')
  nmap('<leader>r', '<cmd>Telescope registers<cr>', 'Content of [R]egisters')
  nmap('<leader>m', '<cmd>Telescope marks<cr>', 'Search [M]arks')
  nmap("<leader>fR", require('telescope.builtin').reloader, "TS: List modules and [r]eload")
end
if has_plugin('telescope') then
  telescope_keymaps()
end

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'java', 'go', 'lua', 'python', 'comment', 'vim', 'markdown',
    'markdown_inline', 'javascript', 'json' },

  -- Autoinstall languages that are not installed.
  auto_install = false,

  -- configure modules
  highlight = { enable = true },
  indent = { enable = true, disable = {} },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-cr>', -- do not bind to <tab>, since C-I (=tab) will be unusable
      node_incremental = '<cr>',
      scope_incremental = '<nop>',
      node_decremental = '<s-cr>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        -- inner and outer have same meaning as ap = around paragraph, ip = inside paragraph
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['al'] = '@loop.outer',        -- for/while loop
        ['il'] = '@loop.inner',
        ['ai'] = '@conditional.outer', -- if statement
        ['ii'] = '@conditional.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
        ['aa'] = '@parameter.outer', -- 'p' stands for paragraph textobject, so use 'a'
        ['ia'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_end = {
        [']m'] = '@function.outer',
        [']c'] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[c'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      -- nodes to swap can be function parameters or arguments
      swap_next = {
        ['<leader>cn'] = { query = '@parameter.inner', desc = 'TS: Swap next fn parameter' }
      },
      swap_previous = {
        ['<leader>cp'] = { query = '@parameter.inner', desc = 'TS: Swap previous fn parameter' }
      },
    },
  },
  playground = {
    enable = true,
  },
}

-- enable folding
if has_plugin('nvim-treesitter') then
  vim.o.foldmethod = 'expr'
  vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
  vim.o.foldenable = false
  vim.o.foldminlines = 2
end

-- [[ Configure neodev, for lua function signature completion ]]
-- make sure to setup neodev BEFORE lspconfig
require('neodev').setup()

-- [[ Configure LSP ]]
local lsp_on_attach_callback = function(args)
  local bufnr = args.buf
  -- lsp keybinds
  do
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    -- LSP keymaps
    nmap('<leader>cr', vim.lsp.buf.rename, '[R]ename identifiers (vars etc)') -- renames correctly within scope
    nmap('<leader>ca', vim.lsp.buf.code_action, 'Code [a]ction')
    nmap('<leader>cf', function() vim.lsp.buf.format { async = true } end, '[F]ormat code')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gt', vim.lsp.buf.type_definition, '[G]oto [T]ype Definition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gh', vim.lsp.buf.hover, '[H]over Documentation')
    nmap('K', vim.lsp.buf.hover, '[H]over Documentation')
    nmap('gk', vim.lsp.buf.signature_help, 'Signature Documentation')
  end

  -- configure diagnostics
  if string.find(args.file, 'snippet') ~= nil then
    -- disable text that appears for error(E), warning (W), hint (H), info (I)
    vim.diagnostic.config({ virtual_text = false })
  end

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- Automatically format code on save
  local lsp_format_setup = function()
    local client = vim.lsp.get_active_clients()[1]
    if client.config
        and client.config.capabilities
        and client.config.capabilities.documentFormattingProvider == false
    then
      return
    end
    local format_is_enabled = true
    vim.api.nvim_create_user_command('FormatOnSaveToggle', function()
      format_is_enabled = not format_is_enabled
      print('Setting autoformatting to: ' .. tostring(format_is_enabled))
    end, {})
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
        buffer = bufnr,
        callback = function()
          if format_is_enabled then
            vim.lsp.buf.format({
              async = false,
              filter = function(c)
                return c.id == client.id
              end,
            })
          end
        end,
      })
    end
  end
  lsp_format_setup()
end

-- Create autocommand to associate a callback when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = lsp_on_attach_callback
})

-- Setup LSP language servers
local lsp_language_servers_setup = function()
  local servers = {
    clangd = {},
    -- jdtls = {},
    pyright = {},
    -- FIXME: lua_ls config is broken. It makes marks disappear
    --   mark 'a' using 'ma' and edit at end of file, save, and mark 'a' disappears
    --
    lua_ls = {
      Lua = {
        diagnostics = { -- Get the language server to recognize the `vim` global
          globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins", "MiniTest" },
        },
        -- removes the startup query about configuring workspace
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local cmp_capabilities = vim.lsp.protocol.make_client_capabilities()
  cmp_capabilities = require('cmp_nvim_lsp').default_capabilities(cmp_capabilities)

  -- Setup floating window border
  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' }),
  }

  for server, _ in pairs(servers) do
    require('lspconfig')[server].setup {
      capabilities = cmp_capabilities,
      settings = servers[server],
      handlers = handlers,
    }
  end
end
lsp_language_servers_setup()

-- [[ Configure jdtls ]]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(args)
        lsp_on_attach_callback(args)
        local map = function(mode, lhs, rhs, desc)
          desc = 'LSP: ' .. desc
          vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
        end
        map('n', "<leader>co", "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports")
        map('v', "<leader>cm", "<cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method")
        map('v', "<leader>cv", "<cmd>lua require('jdtls').extract_variable(true)<cr>", "Extract Variable")
        map('n', "<leader>ct", "<cmd>lua require('jdtls').test_class()<cr>", "Test Class")
        map('n', "<leader>ce", "<cmd>update<CR><cmd>exec '!java' shellescape(@%, 1)<cr>", "Execute file")
      end,
    })

    local jdtls_location = os.getenv('HOMEBREW_PREFIX') .. "/opt/jdtls"
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local ws_base = os.getenv('XDG_DATA_HOME') .. "/eclipse/"
    if ws_base == nil then
      ws_base = os.getenv('HOME') .. "/.local/share/me/eclipse/"
    end
    local workspace_dir = ws_base .. project_name

    -- The nvim-cmp supports additional LSP's capabilities so we need to
    -- advertise it to LSP servers..
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local system = vim.fn.has("mac") == 1 and "mac" or "linux"
    local config = {
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=WARNING",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.fn.glob(jdtls_location .. "/libexec/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        jdtls_location .. "/libexec/config_" .. system,
        "-data",
        workspace_dir,
      },
      root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),
      settings = {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          completion = {
            filteredTypes = { "com.sun.*", "java.awt.*", "jdk.*", "org.graalvm.*", "sun.*", "javax.awt.*",
              "javax.swing.*" }
          },
        }
      },
    }
    require('jdtls').start_or_attach(config)
    require("jdtls.setup").add_commands()
  end,
})


-- [[ Configure nvim-cmp ]]
local cmp = require 'cmp'
-- local luasnip = require 'luasnip'

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
  snippet = {
    expand = function(args)
      -- luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4), -- next to [f]
    ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- [f]orward
    ['<C-Space>'] = cmp.mapping.complete {},
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
  sources = {
    { name = "nvim_lsp" },
    -- { name = "luasnip" },
    { name = 'vsnip' },
    { name = "buffer" },
    { name = "nvim_lsp_signature_help" },
    { name = "dictionary" },
    { name = "path" },
    --{
    --  name = 'look',
    --  keyword_length = 2,
    --  option = {
    --    convert_case = true,
    --    loud = true
    --    --dict = '/usr/share/dict/words'
    --  }
    --}
  },
  window = {
    completion = cmp.config.window.bordered({ winhighlight = 'Cursorline:PmenuSel,Search:None' }),
    documentation = cmp.config.window.bordered({ winhighlight = 'Search:None' }),
  },
}

-- [[ Configure null-ls ]]
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    --null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.black, -- python
    null_ls.builtins.diagnostics.flake8.with({
      extra_args = { "--max-line-length=88", "--ignore=E203" }
    }),                                  -- diagnostics python
    null_ls.builtins.formatting.gersemi, -- cmake
    -- null_ls.builtins.completion.spell, -- spell correction as you type
    -- c/cpp: 7 built-in styles -- LLVM, Google, Chromium, Mozilla, WebKit, Microsoft, GNU
    null_ls.builtins.formatting.clang_format.with({
      -- NOTE: By default it also hooks into java and interferes with jdtls, so only enable for cpp/c
      filetypes = { "cpp", "c" },
      extra_args = { "--style={BasedOnStyle: llvm, ColumnLimit: 80}" }, -- IndentWidth: 2
    }),
  },
})

-- [[ Configure which-key ]]
local keymaps = {
  mode = { "n", "v" },
  ["g"] = { name = "+goto" },
  ["<leader>c"] = { name = "+code" },
  ["<leader>f"] = { name = "+find/telescope" },
  ["<leader>g"] = { name = "+git" },
  ["<leader>u"] = { name = "+ui/toggle +undo" },
  ["<leader>v"] = { name = "+vim" },
}
local wk = require("which-key")
wk.register(keymaps)


-- [[ markdown settings and keybindings ]]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    local map = function(lhs, rhs, desc)
      desc = 'markdown: ' .. desc
      vim.keymap.set({ 'n', 'v' }, lhs, rhs, { buffer = args.buf, desc = desc })
    end
    local fence_code = function(lang)
      local cmd = lang
      if vim.api.nvim_get_mode().mode == 'n' then
        cmd = [[execute "normal! o```]] .. cmd .. [[\<cr>\<cr>```\<esc>k"]]
      else
        cmd = [[execute "normal! \<esc>`<O```]] .. cmd .. [[\<esc>`>o```\<esc>"]]
      end
      vim.cmd(cmd)
    end
    map("<leader>cj", function() fence_code('java') end, "Insert Java Code Block")
    map("<leader>cp", function() fence_code('python') end, "Insert Python Code Block")
    map("<leader>cC", function() fence_code('cpp') end, "Insert Cpp Code Block")
    map("<leader>cc", function() fence_code('') end, "Insert Generic Code Block")
    -- redefine buffer navigation since nvim overrides it in autocmd
    map('[[', '<cmd>bprevious<cr>', 'Prev buffer')
    map(']]', '<cmd>bnext<cr>', 'Next buffer')
    -- Set dark color background for fenced code Block
    -- vim.cmd([[hi @text.literal ctermbg=15, guibg=#161622]])
  end,
})

-- [[ python keybindings ]]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(args)
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = args.buf, desc = desc })
    end
    map("<leader>ce", "<cmd>update<CR><cmd>exec '!python3' shellescape(@%, 1)<cr>", "Run")
    map("<leader>ci",
      "<cmd>cexpr system('refurb --quiet ' . shellescape(expand('%'))) | copen<cr>",
      "Inspect using refurb")
    map("<leader>cp", "<cmd>lua _IPYTHON_TOGGLE()<cr>", "iPython")
  end
})

-- [[ help file ]]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = 'set conceallevel=0', -- there is a bug where it conceals * in *.foo
})

-- debug
-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.markdown = {
--   install_info = {
--     url = "/Users/gp/Projects/tree-sitter-markdown/tree-sitter-markdown", -- local path or git repo
--     files = { "src/parser.c", "src/scanner.c" },
--     -- files = { "src/parser.c", "src/scanner.c" },     -- note that some parsers also require src/scanner.c or src/scanner.cc
--     -- optional entries:
--     -- branch = "main",                        -- default branch in case of git repo if different from master
--     generate_requires_npm = false,          -- if stand-alone parser without npm dependencies
--     requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--   },
--   filetype = "markdown",                    -- if filetype does not match the parser name
-- }

-- [[ Configure modeline ]]
-- The line beneath this is called `modeline`. See `:help modeline`
-- Following line is read by vim even though it is commented out. ts = tab stop, etc.
-- vim: ts=2 sts=2 sw=2 et
