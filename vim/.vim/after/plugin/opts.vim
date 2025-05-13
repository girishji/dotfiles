vim9script

if exists("g:loaded_lsp")
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
