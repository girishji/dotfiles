vim9script

# ---------------------------
# Custom tabline without the X at the end
# ---------------------------
# set tabline=%!g:CustomTabLine()

def! g:CustomTabLine(): string
  var s = ''
  for i in range(tabpagenr('$'))
    var tabnum = i + 1
    s ..= (tabnum == tabpagenr()) ? '%#TabLineSel#' : '%#TabLine#'

    # Make tab clickable and add tab number
    s ..= $'%{tabnum}T'

    # Get the name of the buffer in the current window of this tab
    var winnr = tabpagewinnr(tabnum)
    var buflist = tabpagebuflist(tabnum)
    var bufname = bufname(buflist[winnr - 1])
    var name = fnamemodify(bufname, ':t') ?? '[No Name]'

    # Add space around for padding
    s ..= $' {name}{getbufvar(buflist[winnr - 1], "&mod") ? "[+] " : " "}'
    # s ..= $' {tabnum}:{name} '
  endfor

  # Fill rest of tabline and reset highlight
  s ..= '%#TabLineFill#%T'
  return s
enddef
