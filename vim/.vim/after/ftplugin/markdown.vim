vim9script

hi link markdownCodeBlock Comment

def InCode(s: string): bool
    return synID(line('.'), col('.') - 1, 1)->synIDattr('name') =~? 'markdownCodeBlock'
enddef

iab <buffer> --> ------------------------------------------------------------------------------<c-r>=abbr#Eatchar()<cr>
iab <buffer> ==> ==============================================================================<c-r>=abbr#Eatchar()<cr>

iab <buffer><expr> nn <SID>InCode('nn') ? 'NOTE:' : 'nn'

# Insert '\' in front of <foo> when not in code block.
command EscapeTags {
    for lnum in range(line('$'))
        if synstack(lnum, 1)->mapnew('synIDattr(v:val, "name")')->match('\cmarkdownCodeBlock') == -1
            var line = getline(lnum)
            if line =~ '[^\\]<'
                setline(lnum, line->substitute('\([^\\]\)\(<[a-zA-Z]\)', '\1\\\2', 'g')
            endif
        endif
    endfor
}
