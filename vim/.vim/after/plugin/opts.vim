vim9script

if exists("g:loaded_easyjump")
    # g:easyjump_default_keymap = false
    # nmap , <Plug>EasyjumpJump;
    # omap , <Plug>EasyjumpJump;
    # vmap , <Plug>EasyjumpJump;
endif

if exists("g:loaded_vimcomplete")
    g:vimcomplete_tab_enable = 1
    var dictproperties = {
        python: { sortedDict: false },
        text: { sortedDict: true },
    }
    g:VimCompleteOptionsSet({
        completor: { shuffleEqualPriority: true, alwaysOn: true, kindDisplayType: 'icontext' },
        buffer: { enable: true, maxCount: 10, priority: 11, urlComplete: true, envComplete: true, completionMatcher: 'icase' },
        dictionary: { enable: true, priority: 10, maxCount: 100, filetypes: ['python', 'text'], properties: dictproperties },
        abbrev: { enable: true },
        lsp: { enable: false, maxCount: 10, priority: 8 },
        omnifunc: { enable: true, priority: 10, filetypes: ['python', 'javascript'] },
        vsnip: { enable: true, adaptNonKeyword: true, filetypes: ['python', 'java', 'cpp'] },
        vimscript: { enable: true, priority: 10 },
        ngram: {
            enable: true,
            priority: 10,
            bigram: false,
            filetypes: ['text', 'help', 'markdown'],
            filetypesComments: ['c', 'cpp', 'python', 'java', 'lua', 'vim', 'zsh', 'r'],
        },
    })
endif

if exists("g:loaded_autosuggest")
    g:AutoSuggestSetup({
        search: {
            pum: true,
            fuzzy: false,
            hidestatusline: false,
            alwayson: true,
        },
        cmd: {
            enable: true,
            pum: true,
            hidestatusline: false,
            fuzzy: false,
            exclude: ['^buffer '],
            # exclude: ['^buffer ', '^Find', '^Buffer'],
            onspace: ['buffer'],
            editcmdworkaround: true,
        }
    })
endif

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
        useBufferCompletion: false,
        completionTextEdit: false,
        # snippetSupport: false, # snippets from lsp server
        # vsnipSupport: false,
        ignoreMissingServer: true,
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
        autocmd FileType c,cpp setlocal commentstring=//\ %s |
                    \ command! CommentBlock setlocal commentstring=/*%s*/ |
                    \ command! CommentLines setlocal commentstring=//\ %s
    augroup END
endif

if exists("g:loaded_highlightedyank")
    g:highlightedyank_highlight_duration = 300
endif

if exists("g:loaded_bufline")
    if &background == 'dark'
        # set fillchars+=stl:―,stlnc:—
        set fillchars+=stl:─,stlnc:─
        if &termguicolors
            highlight link user1 statusline
            highlight link user2 statusline
            highlight link user4 statusline
        endif
    else
        highlight link user1 statusline
        highlight link user2 statusline
        highlight link user4 statusline
    endif
    highlight! link StatusLineTerm statusline
    highlight! link StatusLineTermNC statuslinenc
    highlight link user3 statusline
    g:BuflineSetup({ highlight: true, showbufnr: false })
endif
