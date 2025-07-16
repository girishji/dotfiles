vim9script

if exists("g:loaded_lsp")

    # autocmd VimEnter * g:LspOptionsSet({ autoComplete: false, omniComplete: true })
    autocmd VimEnter * g:LspOptionsSet({ autoComplete: false, omniComplete: true, autoHighlightDiags: false })
    # set cpt+=o^10

    # --------------------------
    # LSP Completor
    # --------------------------
    set cpt+=FLspCompletor^5
    def! g:LspCompletor(findstart: number, base: string): any
        var prefix = getline('.')->strpart(0, col('.') - 1)->matchstr('\k\+$')
        # 'clangd' is slow for large files with lots of headers, because it searches all.
        # Trigger after second char and if file is >500 lines.
        var trigger = prefix->len() > 1 || line('$') < 500
        if findstart == 1
            if prefix->empty()
                return -2
            elseif !trigger
                return col('.') - prefix->len() - 1
            else
                return g:LspOmniFunc(findstart, base)
            endif
        endif
        if !trigger
            return {words: [], refresh: 'always'}
        else
            return g:LspOmniFunc(findstart, base)
        endif
    enddef

    # g:LspOptionsSet({
    #     showDiagWithVirtualText: false, # when you set this false, set showDiagOnStatusLine true
    #     autoPopulateDiags: false, # add diags to location list automatically <- :lopen [l ]l
    #     completionMatcher: 'case', # case/fuzzy/icase
    #     # diagSignErrorText: '●',
    #     # diagSignHintText: '●',
    #     # diagSignInfoText: '●',
    #     # diagSignWarningText: '●',
    #     # outlineWinSize: 30,
    #     showSignature: true,
    #     echoSignature: false,
    #     ignoreMissingServer: true,
    # })

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
    if executable('rust-analyzer')
        g:LspAddServer([{
            name: 'rust-analyzer',
            filetype: ['rust'],
            args: [],
            syncInit: v:true,
            path: exepath('rust-analyzer'),
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
    nnoremap <leader>fd <cmd>DevdocsFind<CR>
    # hi link DevdocCode CursorLine
    import autoload 'devdocs/popup.vim' as dp
    dp.OptionsSet({borderhighlight: ['Comment']})
endif

# vim: ts=4 shiftwidth=4 sts=4 expandtab
