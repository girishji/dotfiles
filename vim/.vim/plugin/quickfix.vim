vim9script

# Add current line to quickfix list
#   example: :g/mypattern/caddexpr expand("%") .. ":" .. line(".") ..  ":" .. getline(".")
nnoremap <leader>a <cmd>caddexpr $'{expand("%")}:{line(".")}:{getline(".")}'<cr>
# Clear the current quickfix list
nnoremap <leader>C <cmd>cex []<cr>
# Open qflist
nnoremap <leader>c <cmd>cw<cr>

# Command to save quickfix list to a file
command SaveQuickfixList SaveQuickfixList()

# Save quickfix list on exit
augroup SaveQuickfixList | autocmd!
    autocmd VimLeavePre * call SaveQuickfixList()
augroup END

# File to save
var quickfix_file = expand('~/.vim_quickfix_list.txt')

def SaveQuickfixList()
    writefile(getqflist()->mapnew((_, v) => $'{bufname(v.bufnr)}:{v.lnum}:{v.col}:{v.text}'),
        quickfix_file)
enddef

# Load quickfix list on startup
augroup LoadQuickfixList | autocmd!
    autocmd VimEnter * {
        if (quickfix_file->filereadable())
            :exe 'cgetfile' quickfix_file
        endif
    }
augroup END
