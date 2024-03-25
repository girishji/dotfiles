" :digraphs
" <c-k><char1><char2> will print the utf-8 character
" using 'un', 'bo', 'ii'
if has("conceal")
  syn match helpBold		contained "ぼ" conceal
  syn match helpItalic		contained "і" conceal
  syn match helpUnderline	contained "ぬ" conceal
else
  syn match helpBold		contained "ぼ"
  syn match helpItalic		contained "і"
  syn match helpUnderline	contained "ぬ"
endif

syn match helpBold		"ぼ[^ぼ \t]\+ぼ"hs=s+1,he=e-1 contains=helpBold
syn match helpBold		"\(^\|[^a-z"[]\)\zsぼ[^ぼ]\+ぼ\ze\([^a-z\t."']\|$\)"hs=s+1,he=e-1 contains=helpBold
syn match helpItalic		"і[^і \t]\+і"hs=s+1,he=e-1 contains=helpItalic
syn match helpItalic		"\(^\|[^a-z"[]\)\zsі[^і]\+і\ze\([^a-z\t."']\|$\)"hs=s+1,he=e-1 contains=helpItalic
syn match helpUnderline		"ぬ[^ぬ \t]\+ぬ"hs=s+1,he=e-1 contains=helpUnderline
syn match helpUnderline		"\(^\|[^a-z"[]\)\zsぬ[^ぬ]\+ぬ\ze\([^a-z\t."']\|$\)"hs=s+1,he=e-1 contains=helpUnderline

hi def helpBold cterm=bold term=bold gui=bold
hi def helpItalic cterm=italic term=italic gui=italic
hi def helpUnderline cterm=underline term=underline gui=underline
