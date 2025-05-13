" clear excessive syntax highlighting
try
    syn clear vimFuncName
    syn clear vimSynError
    syn clear vimVar
    syn clear vimOperParen
    syn clear vimFTError
    syn clear vimOperError
    syn clear vimUserAttrbError
    syn clear vimFunctionError
    syn clear vimSynCaseError
catch  " MacVim throws some exception
endtry
