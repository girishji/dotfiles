if exists('g:loaded_lsp')

  autocmd VimEnter * call g:LspOptionsSet({
        \ 'autoComplete': v:false,
        \ 'autoHighlightDiags': v:false
        \ })

  set cpt-=.^5
  set cpt^=.^5,o^7

  if executable('clangd')
    call g:LspAddServer([{
          \ 'name': 'clangd',
          \ 'filetype': ['c', 'cpp'],
          \ 'path': 'clangd',
          \ 'args': ['--background-index']
          \ }])
  endif

  if executable('pylsp')
    " see ~/.config/pycodestyle
    call g:LspAddServer([{
          \ 'name': 'pylsp',
          \ 'filetype': ['python'],
          \ 'path': exepath('pylsp')
          \ }])
  endif

  if executable('typescript-language-server')
    call g:LspAddServer([{
          \ 'name': 'typescript-language-server',
          \ 'filetype': ['javascript', 'typescript'],
          \ 'path': 'typescript-language-server',
          \ 'args': ['--stdio'],
          \ 'rootSearch': [
          \   'tsconfig.json',
          \   'package.json',
          \   'jsconfig.json',
          \   '.git'
          \ ]
          \ }])
  endif

  if executable('rust-analyzer')
    call g:LspAddServer([{
          \ 'name': 'rust-analyzer',
          \ 'filetype': ['rust'],
          \ 'args': [],
          \ 'syncInit': v:true,
          \ 'path': exepath('rust-analyzer')
          \ }])
  endif

  if executable('jdtls')
    call g:LspAddServer([{
          \ 'name': 'jdtls',
          \ 'filetype': ['java'],
          \ 'path': exepath('jdtls'),
          \ 'args': [
          \   '-configuration', expand('$HOME') . '/.cache/jdtls',
          \   '-data', expand('$HOME') . '/.local/share/me/eclipse'
          \ ],
          \ 'initializationOptions': {
          \   'settings': {
          \     'java': {
          \       'contentProvider': { 'preferred': 'fernflower' },
          \       'completion': {
          \         'filteredTypes': [
          \           'com.sun.*', 'java.awt.*', 'jdk.*',
          \           'org.graalvm.*', 'sun.*', 'javax.awt.*',
          \           'javax.swing.*'
          \         ]
          \       }
          \     }
          \   }
          \ }
          \ }])
  endif

endif

" vim: ts=4 shiftwidth=4 sts=4 expandtab
