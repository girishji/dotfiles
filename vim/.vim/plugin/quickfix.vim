vim9script

# Add current line to quickfix list
#   example: :g/mypattern/caddexpr expand("%") .. ":" .. line(".") ..  ":" .. getline(".")
nnoremap <leader>a <cmd>caddexpr $'{expand("%")}:{line(".")}:{getline(".")}'<cr>
# Clear the current quickfix list
nnoremap <leader>C <cmd>cex []<cr>
# Save quickfix list to a file
command SaveQuickfixList SaveQuickfixList()

# Save quickfix list on exit and load on startup
augroup SaveQuickfixList | autocmd!
    autocmd VimLeave * call SaveQuickfixList()
augroup END

var quickfix_file = expand('~/.vim_quickfix_list.txt')

def SaveQuickfixList()
    var items = getqflist()

    if !empty(items)
        var serialized = []
        for item in items
            call add(serialized,
                bufname(item.bufnr) .. ':' ..
                item.lnum .. ':' ..
                item.col .. ':' ..
                item.text)
        endfor
        writefile(serialized, quickfix_file)
    endif
enddef

# Optionally, load quickfix list on startup
augroup LoadQuickfixList | autocmd!
    autocmd VimEnter * {
        if (quickfix_file->filereadable())
            :exe $'cgetfile {quickfix_file}'
        endif
    }
augroup END
