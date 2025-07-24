" ======================================================================
" Ruler

set laststatus=0 ruler
set highlight-=S:StatusLineNC highlight+=Si
augroup ruler_toggle
  autocmd!
  autocmd WinEnter,BufEnter * setl rulerformat=%65(%=𜰟\ %-t%{&modified?'[+]':''}\ 𜰟\ %{bufexists(bufnr('#'))&&(bufname(bufnr('#'))!='')&&bufnr('#')!=bufnr('%')?'('.(fnamemodify(bufname(bufnr('#')),':t').(getbufvar(bufnr('#'),'&modified')?'[+]':'').'#)\ '):''}%y%{&ft==''?'':'\ '}%l,%c%V\ %P%)
  autocmd WinEnter,BufEnter * setl statusline=%=%-t%{&modified?'[+]':''}\ ≡\ %{bufexists(bufnr('#'))&&(bufname(bufnr('#'))!='')&&bufnr('#')!=bufnr('%')?'<'.(fnamemodify(bufname(bufnr('#')),':t').(getbufvar(bufnr('#'),'&modified')?'[+]':'').'#>\ '):''}%y%{&ft==''?'':'\ '}%l,%c%V\ %P\ 
  autocmd WinLeave * setl statusline=%=\ %-t\ |:
augroup END

" vim: shiftwidth=2 sts=2 expandtab
