vim9script

if executable('black')
    &l:formatprg = "black -q - 2>/dev/null"
elseif executable('yapf')
    &l:formatprg = "yapf"
endif

setlocal foldignore=

b:undo_ftplugin ..= ' | setl foldignore< formatprg< | silent! autocmd! PythonAutoImport'

# Convince python that 'def' is a macro like C's #define
setlocal define=^\\s*def

setl dictionary=$HOME/.vim/data/python.dict
setl makeprg=python3\ %

if exists("g:loaded_pythondoc")
    import 'pythondoc_abbrev.vim' as abbrev
    abbrev.ExpandHH()
    nnoremap <buffer> <leader>H :Help<space>
endif

# NOTE: tidy-imports misses some imports. Put them in ~/.pyflyby
# nnoremap <buffer> <leader>vh :term ++close pydoc3<space>
# nnoremap <buffer> <leader>vb :!open https://docs.python.org/3/search.html\?q=
# nnoremap <buffer> <leader>vf :% !black -q -<cr>

# You can use :w !cmd to write the current buffer to the stdin of an external
# command. A related command is :%!cmd which does the same thing and then
# replaces the current buffer with the output of the command. (:h :range!)
nnoremap <buffer> <leader>vi ::% !tidy-imports --replace-star-imports -r -p --quiet --black<cr>

# Works, but intrusive
# augroup PythonAutoImport | autocmd!
#     autocmd bufwritepre * {
#         if &ft == 'python' && 'tidy-imports'->executable()
#             :% !tidy-imports --replace-star-imports -r -p --quiet --black
#         endif
#     }
# augroup END

nnoremap <buffer><expr> <leader>vt $":new \| exec 'nn <buffer> q :bd!\<cr\>' \| 0read !leetcode test {bufname()->fnamemodify(':t')->matchstr('^\d\+')}<cr>"
nnoremap <buffer><expr> <leader>vx $":new \| exec 'nn <buffer> q :bd!\<cr\>' \| 0read !leetcode exec {bufname()->fnamemodify(':t')->matchstr('^\d\+')}<cr>"
nnoremap <buffer> <leader>vp :new \| exec 'nn <buffer> q :bd!\<cr\>' \| r !python3 #<cr>
nnoremap <buffer> <leader>p :Ipython<cr>
g:pyindent_open_paren = 'shiftwidth()' # https://github.com/vim/vim/blob/v8.2.0/runtime/indent/python.vim

# Abbreviations

def GetSurroundingFn(): string
    var fpat = '\vdef\s+\zs\k+'
    var lnum = search(fpat, 'nb')
    if lnum > 0
        var fname = getline(lnum)->matchstr(fpat) .. '()'
        var cpat = '\vclass\s+\zs\k+'
        lnum = search(cpat, 'nb')
        if lnum > 0
            return getline(lnum)->matchstr(cpat) .. '().' .. fname
        endif
        return fname
    endif
    return ''
enddef

iabbr <buffer><expr> def      abbr#NotCtx('def') ? 'def' : 'def ):<cr><esc>-f)i<c-r>=abbr#Eatchar()<cr>'
iabbr <buffer>       def_     def ():<cr>"""."""<esc>-f(i<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       def__    def ():<c-o>o'''<cr>>>> print()<cr><cr>'''<esc>4k_f(i<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       try_ try:
            \<cr>pass
            \<cr>except Exception as err:
            \<cr>print(f"Unexpected {err=}, {type(err)=}")
            \<cr>raise<cr>else:
            \<cr>pass<esc>5kcw<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       main__2
            \ if __name__ == "__main__":
            \<cr>import doctest
            \<cr>doctest.testmod()<esc><c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       main__
            \ if __name__ == "__main__":
            \<cr>main()<esc><c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       python3#    #!/usr/bin/env python3<esc><c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       '''_ '''
            \<cr>>>> print(<c-r>=<SID>GetSurroundingFn()<cr>)
            \<cr>'''<esc>ggOfrom sys import stderr<esc>Go<c-u><esc>o<esc>
            \:normal i__main__<cr>
            \?>>> print<cr>:nohl<cr>g_hi<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       """            """."""<c-o>3h<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       case_ match myval:
            \<cr>case 10:
            \<cr>pass
            \<cr>case _:<esc>3k_fm;i<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       match_case_ match myval:
            \<cr>case 10:
            \<cr>pass
            \<cr>case _:<esc>3k_fm;i<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       enum_          Color = Enum('Color', ['RED', 'GRN'])<esc>_fC<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       pre            print(, file=stderr)<esc>F,i<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       pr             print()<c-o>i<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       tuple_         Point = namedtuple('Point', 'x y')<esc>_<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>       tuple_named    Point = namedtuple('Point', ('x', 'y'), defaults=(None,) * 2)<esc>_<c-r>=abbr#Eatchar()<cr>
# collections
iabbr  <buffer>  defaultdict1   defaultdict(int)<c-r>=abbr#Eatchar()<cr>
iabbr  <buffer>  defaultdict_   defaultdict(set)<c-r>=abbr#Eatchar()<cr>
iabbr  <buffer>  defaultdict3   defaultdict(lambda: '[default  value]')<c-r>=abbr#Eatchar()<cr>
iabbr  <buffer>  dict_default1  defaultdict(int)<c-r>=abbr#Eatchar()<cr>
#
iabbr <buffer>   cache_          @functools.cache<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>   __init__        def __init__(self):<esc>hi<c-r>=abbr#Eatchar()<cr>
iabbr <buffer>   __add__         def __add__(self, other):<cr><c-r>=abbr#Eatchar()<cr>
iabbr <buffer>   __sub__         def __sub__(self, other):<cr><c-r>=abbr#Eatchar()<cr>
iabbr <buffer>   __mul__         def __mul__(self, other):<cr><c-r>=abbr#Eatchar()<cr>
iabbr <buffer>   __truediv__     def __truediv__(self, other):<cr><c-r>=abbr#Eatchar()<cr>
iabbr <buffer>   __floordiv__    def __floordiv__(self, other):<cr><c-r>=abbr#Eatchar()<cr>

# commands

# Reuse terminal running ipython or start a new one
def Ipython()
    var listedbufs = getbufinfo({buflisted: 1})
    var ipbufidx = listedbufs->indexof((_, v) => v.name =~? 'ipython')
    if ipbufidx != -1
        var ipbufnr = listedbufs[ipbufidx].bufnr
        if bufwinnr(ipbufnr) == -1
            # ipython opthons can be placed in a config file
            exec $'sbuffer {listedbufs[ipbufidx].bufnr}'
        endif
    else
        :term ++close ++kill=term ipython3 --no-confirm-exit --colors=Linux
    endif
enddef
command Ipython Ipython()

# popup menu

if exists('g:loaded_scope')
    import autoload 'scope/popup.vim'
    def Things()
        var things = []
        for nr in range(1, line('$'))
            var line = getline(nr)
            if line =~ '\(^\|\s\)\(def\|class\) \k\+('
                    || line =~ 'if __name__ == "__main__":'
                things->add({text: $"{line} ({nr})", linenr: nr})
            endif
        endfor
        popup.FilterMenu.new("Py Things", things,
            (res, key) => {
                exe $":{res.linenr}"
                normal! zz
            },
            (winid, _) => {
                win_execute(winid, $"syn match FilterMenuLineNr '(\\d\\+)$'")
                hi def link FilterMenuLineNr Comment
            })
    enddef
endif

if exists(":LspDocumentSymbol") == 2
    # nnoremap <buffer> <leader>/ <cmd>LspDocumentSymbol<CR>
    nnoremap <buffer> <space>z <scriptcmd>Things()<CR>
elseif exists('g:loaded_scope')
    nnoremap <buffer> <space>/ <scriptcmd>Things()<CR>
endif

