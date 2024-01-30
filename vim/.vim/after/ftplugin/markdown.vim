vim9script

nnoremap <buffer> <leader>` ciw``<esc>P
setl spell
b:undo_ftplugin ..= ' | setl spell<'
