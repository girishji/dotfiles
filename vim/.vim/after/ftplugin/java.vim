vim9script

# Convince java that 'class' is a macro like C's #define
setlocal define=^\\s*class
b:undo_ftplugin ..= ' | setlocal define<'

## Make jdtls 'code actions' do 'organize imports', 'add unimplemented methods', etc.,
#var jfname = $'{$HOME}/.vim/plugged/lsp/autoload/lsp/textedit.vim'
#if filereadable(jfname) && exists("g:loaded_lsp")
#    import jfname
#    def g:JavaWorkspaceEdit(cmd: dict<any>)
#        for editAct in cmd.arguments
#            textedit.ApplyWorkspaceEdit(editAct)
#        endfor
#    enddef
#    g:LspRegisterCmdHandler('java.apply.workspaceEdit', g:JavaWorkspaceEdit)
#endif
