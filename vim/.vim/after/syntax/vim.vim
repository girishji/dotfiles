" https://github.com/habamax/.vim/blob/master/after/syntax/vim.vim
" fix marks incorrectly highlighted
" :'[,']sort
syn match vimExMarkRange /\(^\|\s\):['`][\[a-zA-Z0-9<][,;]['`][\]a-zA-Z0-9>]/

" clear excessive syntax highlighting
syn clear vimFuncName
syn clear vimVar
syn clear vimOperParen
syn clear vimFTError
syn clear vimOperError
syn clear vimUserAttrbError
syn clear vimFunctionError
syn clear vimSynCaseError
