vim9script

if exists("g:loaded_lsp")

    autocmd VimEnter * g:LspOptionsSet({ autoComplete: false, autoHighlightDiags: false })

    set cpt-=.^5
    set cpt^=.^5,o^7

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

# vim: ts=4 shiftwidth=4 sts=4 expandtab
