vim9script

if exists("g:loaded_vimbits")
    # g:easyjump_default_keymap = false
    # nmap , <Plug>EasyjumpJump;
    # omap , <Plug>EasyjumpJump;
    # vmap , <Plug>EasyjumpJump;
    # highlight link FfTtSubtle NonText
endif

if exists("g:loaded_vimcomplete")
    var dictproperties = {
        python: { sortedDict: false },
        text: { sortedDict: true },
        cpp: { sortedDict: false },
    }
    g:VimCompleteOptionsSet({
        completor: { triggerWordLen: 0, shuffleEqualPriority: true, alwaysOn: true, postfixClobber: false, postfixHighlight: true, debug: false },
        buffer: { enable: true, maxCount: 10, priority: 11, urlComplete: true, envComplete: true, completionMatcher: 'icase' },
        dictionary: { enable: true, priority: 10, maxCount: 100, filetypes: ['python', 'text', 'cpp'], properties: dictproperties },
        abbrev: { enable: true },
        lsp: { enable: true, maxCount: 10, priority: 8 },
        omnifunc: { enable: false, priority: 10, filetypes: ['tex', 'python'] },
        vsnip: { enable: true, adaptNonKeyword: true, filetypes: ['python', 'java', 'cpp'] },
        vimscript: { enable: true, priority: 10 },
        tmux: { enable: false },
        tag: { enable: false },
        ngram: {
            enable: true,
            priority: 10,
            bigram: false,
            filetypes: ['text', 'help', 'markdown', 'txt'],
            filetypesComments: ['c', 'cpp', 'python', 'java', 'lua', 'vim', 'zsh', 'r'],
        },
    })
    g:VimCompleteInfoPopupOptionsSet({
        borderhighlight: ['Comment'],
    })
endif

if exists("g:loaded_vimsuggest")
    var VimSuggest = {}
    VimSuggest.search = {
        # enable: false,
        # alwayson: false,
        pum: false,
        # ctrl_np: true,
        # fuzzy: false,
        # reverse: true,
    }
    VimSuggest.cmd = {
        # enable: false,
        # alwayson: false,
        # ctrl_np: true,
        # pum: true,
        # fuzzy: true,
        # exclude: ['^\s*\d*\s*b\%[uffer]!\?\s\+'],
        # onspace: ['colo\%[rscheme]', 'b\%[uffer]', 'e\%[dit]', 'Scope'],
        onspace: '.*',
        # reverse: true,
        # auto_first: true,  # :hi will not call ':highlight' but calls ':HighlightGroupUnderCursor'
        popupattrs: {
            borderchars: ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
            # borderhighlight: ['Normal'],
            # highlight: 'Normal',
            border: [0, 1, 0, 1],
            # padding: [1, 1, 1, 1],
            # maxheight: 20,
        },
    }
    g:VimSuggestSetOptions(VimSuggest)

    augroup vimsuggest-qf-show
        autocmd!
        autocmd QuickFixCmdPost clist cwindow
    augroup END

    # find
    # g:vimsuggest_fzfindprg = 'fd --type f .'
    # g:vimsuggest_shell = true
    set shell=/bin/zsh
    set shellcmdflag=-c
    nnoremap <leader><space> :VSFind<space>
    # nnoremap <leader><space> :VSGitFind<space>
    nnoremap <leader>fv :VSFind ~/.vim<space>
    nnoremap <leader>fz :VSFind ~/.zsh/<space>
    nnoremap <leader>fV :VSFind $VIMRUNTIME<space>

    nnoremap <leader>/ :VSGlobal<space>
    nnoremap <leader>; :VSInclSearch<space>

    # live find
    # g:vimsuggest_shell = true
    # g:vimsuggest_findprg = 'fd --type f --glob'
    # g:vimsuggest_findprg = 'fd --type f'
    g:vimsuggest_findprg = 'find -EL $* \! \( -regex ".*\.(zwc\|swp\|git\|zsh_.*)" -prune \) -type f -name $*'
    nnoremap <leader>ff :VSFindL "*"<left><left>

    nnoremap <leader>fF :VSExec fd --type f<space>
    # nnoremap <leader>fF find -EL . \! \( -regex ".*\.(zwc\|swp\|git\|zsh_.*)" -prune \) -type f -name "*"<left><left>

    # XXX: If you use 'find ~/.zsh', it shows nothing since -path matches whole path and dot dirs (including .zsh) are excluded.
    # nnoremap <leader>ff :VSCmd e find . \! \( -path "*/.*" -prune \) -type f -name "*"<left><left>
    # Live grep (see notes in .zsh dir)
    # nnoremap <leader>g :VSExec ggrep -REIHins "" . --exclude-dir={.git,"node_*"} --exclude=".*"<c-left><c-left><c-left><left><left>
    # NOTE: '**' automatically excludes hidden dirs and files, but it is much slower.
    # nnoremap <leader>g :VSExec grep -IHSins "" **/*<c-left><left><left>
    # XXX '~' does not work with Vim
    # nnoremap <leader>g :VSExec grep -IHins "" . **/*\~node_modules/*<c-left><left><left><left><left>

    # Live grep
    g:vimsuggest_grepprg = 'ggrep -REIHins $* --exclude-dir=.git --exclude=".*"'
    # g:vimsuggest_grepprg = 'rg --vimgrep --smart-case $* .'
    # g:vimsuggest_grepprg = 'ag --vimgrep'
    nnoremap <leader>g :VSGrep ""<left>
    nnoremap <leader>G :VSGrep "<c-r>=expand('<cword>')<cr>"<left>

    nnoremap <leader><bs> :VSBuffer<space>

    nnoremap <leader>fk :VSKeymap<space>
    nnoremap <leader>fr :VSRegister<space>
    nnoremap <leader>fm :VSMark<space>

    # :find ** -> lists directories     also
    # None of the following can descend into directories correctly
    #
    # with zsh -c, slow
    # nnoremap <leader><space> :VSCmd e find 2>/dev/null **/*(.N)<left><left><left><left><left>
    # nnoremap <leader><space> :VSCmd e find 2>/dev/null **/*~.git/*(.N)<c-left><right><right><right>
    # nnoremap <leader><space> :VSCmd e find **/*(.N)<left><left><left><left><left>
    #
    # dev null needs 'sh -c'
    # 10x faster than "**" solution
    # nnoremap <leader><space> :VSCmd e find . -type f -name "*" 2>/dev/null<c-left><left><left>
    #
    # import autoload 'vimsuggest/extras/vscmd.vim'
    # vscmd.shellprefix = 'sh -c'
    # vscmd.shellprefix = 'zsh -o extendedglob -c'
    #
    # no /dev/null needed if you don't print error
    # nnoremap <leader><space> :VSCmd e find . -path "*/.git" -prune -o -type f -name "*"<left><left>

    # nnoremap <leader><space> :VSCmd e find -E . \! \( -regex ".*\.(zwc\|swp\|git\|zsh_.*)" -prune \) -type f -name "*"<left><left>

    # import autoload 'vimsuggest/extras/vsfind.vim'
    # var cmdstr = 'find -E . \! \( -regex ".*\.(zwc\|swp\|git\|zsh_.*)" -prune \) -type f -name'
    # def FindCompletor(context: string, line: string, cursorpos: number): list<any>
    #     return vsfind.Completor(context, line, cursorpos, cmdstr)
    # enddef
    # def FindAction(arg: string)
    #     vsfind.Action('e', cmdstr, arg)
    # enddef
    # command! -nargs=+ -complete=customlist,FindCompletor Find FindAction(<f-args>)
    # nnoremap <leader><space> :Find *<left>

    # command! -nargs=+ -complete=customlist,FindCompletor Find vsfind.DoCommand(<f-args>)
    # nnoremap <leader><space> :Find e "*"<left><left>
    # command! -nargs=1 -complete=customlist,FindCompletor Find FindAction(<f-args>)

    # var grepcmd = 'grep -REIHSins --exclude="{.gitignore,.swp,.zwc,tags,./.git/*}"'
    # grep --color=never -REIHSins --exclude="{.{gitignore,swp,zwc},{tags,./.git/*}}"

    #  grep --color=never -REIHSins --exclude=".gitignore" --exclude="*.swp" --exclude="*.zwc" --exclude="tags" --exclude="./.git/*" a
    # def GrepCompletor(context: string, line: string, cursorpos: number): list<any>
    #     return vsfind.Completor(context, line, cursorpos, grepcmd, 'zsh -c')
    # enddef
    # def GrepAction(arg: string)
    #     vsfind.Action('e', grepcmd, arg)
    # enddef
    # command! -nargs=+ -complete=customlist,FindCompletor Find FindAction(<f-args>)
    # nnoremap <leader>fg :Grep<space>
    #
    # command -nargs=1 Find VSCmd e find -E . \! \( -regex ".*\.(zwc\|swp\|git\|zsh_.*)" -prune \) -type f -name
    # nnoremap <leader><space> :Find "*"<left><left>
    #
    # 'ls' with ** is slow
    # ls lists directories when file glob fails. (N) removes (.) when (.) fails.
    # nnoremap <leader><space> :VSCmd e ls -1 **/*(.N)<left><left><left><left><left>
endif

# if exists("g:loaded_autosuggest")
#     g:AutoSuggestSetup({
#         search: {
#             enable: true,
#             pum: false,
#             fuzzy: false,
#             alwayson: true,
#         },
#         cmd: {
#             enable: true,
#             pum: true,
#             fuzzy: false,
#             exclude: ['^b$', '^e$', '^v$'],
#             # exclude: ['^buffer ', '^Find', '^Buffer'],
#             editcmdworkaround: true,
#         }
#     })
# endif

if exists("g:loaded_lsp")
    g:LspOptionsSet({
        autoHighlightDiags: true,
        showDiagWithVirtualText: false, # when you set this false, set showDiagOnStatusLine true
        highlightDiagInline: true,
        showDiagOnStatusLine: true,
        diagVirtualTextAlign: 'after',
        autoPopulateDiags: false, # add diags to location list automatically <- :lopen [l ]l
        # completionMatcher: 'fuzzy', # case/fuzzy/icase
        completionMatcher: 'case', # case/fuzzy/icase
        diagSignErrorText: '●',
        diagSignHintText: '●',
        diagSignInfoText: '●',
        diagSignWarningText: '●',
        # outlineWinSize: 30,
        showSignature: true,
        echoSignature: false,
        # vsnipSupport: false,
        ignoreMissingServer: true,
        # autoComplete: false,  # when false, it sets omnifunc (use <c-x><c-o>)
    })
    if executable('clangd')
        g:LspAddServer([{
            name: 'clangd',
            filetype: ['c', 'cpp'],
            path: 'clangd',
            args: ['--background-index']
        }])
    endif
    if executable('pylsp')
        # see ~/.config/pycodestyle
        g:LspAddServer([{
            name: 'pylsp',
            filetype: ['python'],
            path: exepath('pylsp'),
            # debug: true,
        }])
    endif
    if executable('typescript-language-server')
        g:LspAddServer([{
            name: 'typescript-language-server',
            filetype: ['javascript', 'typescript'],
            path: 'typescript-language-server',
            args: ['--stdio'],
            rootSearch: ['tsconfig.json', 'package.json', 'jsconfig.json', '.git'],
        }])
    endif
    # if executable('gopls')
    #     g:LspAddServer([{
    #         name: 'gopls',
    #         filetype: 'go',
    #         path: 'gopls',
    #         args: ['serve']
    #     }])
    # endif
    if executable('jdtls')
        g:LspAddServer([{
            # Note:
            # - use <tab> to place implementation skeleton of method ('t' <tab> <space> you get toString() in jdtls)
            # - invoke code action to organize imports
            name: 'jdtls',
            filetype: ['java'],
            path: exepath('jdtls'),
            args: [
                "-configuration", expand("$HOME") .. "/.cache/jdtls",
                "-data", expand("$HOME") .. "/.local/share/me/eclipse",
            ],
            # https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line
            initializationOptions: {
                settings: {
                    java: {
                        contentProvider: { preferred: "fernflower" },
                        completion: {
                            # exclude the following from completion suggestions
                            filteredTypes: [ "com.sun.*", "java.awt.*", "jdk.*",
                                        \ "org.graalvm.*", "sun.*", "javax.awt.*",
                                        \ "javax.swing.*" ],
                        },
                    },
                },
            },
        }])
    endif
    def LSPUserSetup()
        nnoremap <buffer> [e :LspDiagPrev<CR>| # think as 'error' message
        nnoremap <buffer> ]e :LspDiagNext<CR>
        if &background == 'dark'
            highlight  LspDiagVirtualTextError    ctermbg=none  ctermfg=1
            highlight  LspDiagVirtualTextWarning  ctermbg=none  ctermfg=3
            highlight  LspDiagVirtualTextHint     ctermbg=none  ctermfg=2
            highlight  LspDiagVirtualTextInfo     ctermbg=none  ctermfg=5
        endif
        highlight  link  LspDiagSignErrorText    LspDiagVirtualTextError
        highlight  link  LspDiagSignWarningText  LspDiagVirtualTextWarning
        highlight  link  LspDiagSignHintText     LspDiagVirtualTextHint
        highlight  link  LspDiagSignInfoText     LspDiagVirtualTextInfo
        highlight LspDiagInlineWarning ctermfg=none
        highlight LspDiagInlineHint ctermfg=none
        highlight LspDiagInlineInfo ctermfg=none
        highlight LspDiagInlineError ctermfg=none cterm=undercurl
        highlight LspDiagVirtualText ctermfg=1
        highlight LspDiagLine ctermbg=none
    enddef
    autocmd User LspAttached LSPUserSetup()
endif

if exists("g:loaded_swap")
    g:swap_no_default_key_mappings = 1
    nmap g< <Plug>(swap-prev)
    nmap g> <Plug>(swap-next)
endif

if exists("g:loaded_gitgutter")
    g:gitgutter_map_keys = 0
    nmap ]h <Plug>(GitGutterNextHunk)
    nmap [h <Plug>(GitGutterPrevHunk)
    hi GitGutterAdd ctermfg=5 | hi GitGutterChange ctermfg=5 | hi GitGutterDelete ctermfg=5
    # Disable these problematic autocmds, otherwise :vimgrep gives error when opening quickfix
    if exists("#gitgutter")
        autocmd! gitgutter QuickFixCmdPre *vimgrep*
        autocmd! gitgutter QuickFixCmdPost *vimgrep*
    endif
endif

if exists("g:loaded_commentary")
    augroup MyVimCommentary | autocmd!
        autocmd FileType c,cpp {
            setlocal commentstring=//\ %s
            # command! CommentBlock setlocal commentstring=/*%s*/
            # command! CommentLines setlocal commentstring=//\ %s
        }
    augroup END
endif

if exists("g:loaded_bufline")
    if &background == 'dark'
        # - `User1`: Active buffer
        # - `User2`: Alternate buffer
        # - `User3`: Other buffers
        # - `User4`: Emphasis characters if specified (see Options)
        # highlight user1 ctermfg=252 cterm=underline,bold
        # highlight user2 ctermfg=252 cterm=bold,italic
        # highlight user3 ctermfg=252 cterm=none
        # highlight user4 ctermfg=252 cterm=bold
        # g:BuflineSetup({ highlight: true, showbufnr: false, emphasize: '' })
    else
        # keep defaults
    endif
    # g:BuflineSetup({ highlight: false, showbufnr: false, emphasize: '<%#' })
    g:BuflineSetup({ highlight: true, emphasize: '#' })
endif

# another way
# if exists('g:loaded_devdocs')
#     import autoload 'devdocs/install.vim'
#     import autoload 'devdocs/uninstall.vim'
#     import autoload 'devdocs/find.vim'
#     nnoremap <leader>I <scriptcmd>install.Install()<CR>
#     nnoremap <leader>U <scriptcmd>uninstall.Uninstall()<CR>
#     nnoremap <leader>h <scriptcmd>find.Find()<CR>
#     hi link DevdocCode CursorLine
# endif

if exists('g:loaded_devdocs')
    nnoremap <leader>vv <cmd>DevdocsFind<CR>
    # nnoremap <leader>I <cmd>DevdocsInstall<CR>
    # nnoremap <leader>U <cmd>DevdocsUninstall<CR>
    # hi link DevdocCode CursorLine
    # g:DevdocsPopupOptionsSet({borderhighlight: ['Comment']})
    import autoload 'devdocs/popup.vim' as dp
    dp.OptionsSet({borderhighlight: ['Comment']})
endif

if exists('g:loaded_scope')
    import autoload 'scope/popup.vim' as sp
    import autoload 'scope/fuzzy.vim'
    import autoload 'scope/util.vim'

    sp.OptionsSet({
        borderhighlight: ['Comment'],
        # maxheight: 20,
        # maxwidth: 80,
        # emacsKeys: true,
    })

    fuzzy.OptionsSet({
        grep_highlight_ignore_case: false,
        grep_echo_cmd: true,
        find_echo_cmd: true,
    })

    nnoremap <leader><space> <scriptcmd>fuzzy.File()<CR>
    def FindGit()
        var gitdir = system("git rev-parse --show-toplevel 2>/dev/null")->trim()
        if v:shell_error != 0 || gitdir == getcwd()
            gitdir = '.'
        endif
        fuzzy.File(fuzzy.FindCmd(gitdir))
    enddef
    nnoremap <leader>ff <scriptcmd>FindGit()<cr>
    # nnoremap <leader>ff <scriptcmd>fuzzy.File(fuzzy.FindCmd($'{system("git rev-parse --show-toplevel 2>/dev/null \|\| true")->trim()}'))<cr>

    # note: <scriptcmd> sets the context of execution to the fuzzy.vim script, so 'findcmd' var is not visible, as in:
    # var findcmd = 'fd -tf -L . /Users/gp/.vim'

    command -nargs=1 -complete=dir ScopeFile fuzzy.File(fuzzy.FindCmd(<f-args>))
    # command -nargs=1 -complete=dir ScopeFile fuzzy.File($'fd -tf --follow . {<f-args>}')
    nnoremap <leader>fF :ScopeFile<space>
    nnoremap <leader>fv <scriptcmd>fuzzy.File(fuzzy.FindCmd($'{$HOME}/.vim'))<CR>
    nnoremap <leader>fV <scriptcmd>fuzzy.File(fuzzy.FindCmd($VIMRUNTIME))<CR>
    nnoremap <leader>fh <scriptcmd>fuzzy.File(fuzzy.FindCmd($'{$HOME}/help'))<CR>
    nnoremap <leader>fz <scriptcmd>fuzzy.File(fuzzy.FindCmd($'{$HOME}/.zsh'))<CR>

    command -nargs=1 -complete=dir ScopeGrepDir fuzzy.Grep(null_string, true, null_string, <f-args>)
    # command -nargs=1 -complete=dir ScopeGrepDir fuzzy.Grep('rg --vimgrep', true, null_string, <f-args>)
    nnoremap <leader>fg :ScopeGrepDir<space>
    nnoremap <leader>g <scriptcmd>fuzzy.Grep()<CR>
    # case sensitive grep
    nnoremap <leader>fG <scriptcmd>fuzzy.Grep(fuzzy.GrepCmd('-RESIHns'))<CR>
    # cword
    nnoremap <leader>G <scriptcmd>fuzzy.Grep(null_string, true, '<cword>')<CR>
    # for testing
    # nnoremap <leader>g <scriptcmd>fuzzy.Grep('rg --vimgrep --no-heading --smart-case')<CR>
    # nnoremap <leader>g <scriptcmd>fuzzy.Grep('ag --vimgrep')<CR>

    nnoremap <leader><bs> <scriptcmd>fuzzy.Buffer()<CR>
    nnoremap <leader>fb <scriptcmd>fuzzy.Buffer(true)<CR>

    nnoremap <leader>f/ <scriptcmd>fuzzy.BufSearch()<CR>
    nnoremap <leader>fH <scriptcmd>fuzzy.Highlight()<CR>
    nnoremap <leader>fk <scriptcmd>fuzzy.Keymap()<CR>
    nnoremap <leader>fm <scriptcmd>fuzzy.Mark()<CR>
    nnoremap <leader>fr <scriptcmd>fuzzy.Register()<CR>
    nnoremap <leader>fw <scriptcmd>fuzzy.Window()<CR>
    nnoremap <leader>fQ <scriptcmd>fuzzy.QuickfixHistory()<CR>
    nnoremap <leader>fq <scriptcmd>fuzzy.Quickfix()<CR>

    if exists(":LspDocumentSymbol") == 2
        nnoremap <leader>/ <scriptcmd>fuzzy.LspDocumentSymbol()<CR>
    endif
endif
