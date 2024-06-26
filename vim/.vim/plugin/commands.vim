vim9script

def SetupCscope()
    if filereadable('./cscope.out')
        cscope add ./cscope.out
    elseif filereadable('./../cscope.out')
        cscope add ./../cscope.out
    elseif filereadable(expand('~/cscope/cscope.out'))
        cscope add ~/cscope/cscope.out
    endif
enddef
command CscopeDB SetupCscope()

# Find highlight group under cursor
def SynStack()
    if !exists("*synstack") | return | endif
    echo synstack(line('.'), col('.'))->map('synIDattr(v:val, "name")')
enddef
command HighlightGroupUnderCursor SynStack()

# Toggle folding of all folds in buffer (zR, zM)
var myfoldingtoggleflag = false
def FoldingToggle()
    exec myfoldingtoggleflag ? 'normal! zR' : 'normal! zM'
    myfoldingtoggleflag = !myfoldingtoggleflag
enddef
command FoldingToggle FoldingToggle()

# Open image in MacOs
def ShowImage()
    if expand('<cfile>') != null_string
        :silent vim9cmd system($'qlmanage -p {expand("<cfile>:p")}')
    else
        for word in getline('.')->split()
            if filereadable(expand(word))
                :silent vim9cmd system($'qlmanage -p {fnamemodify(expand(word), ":p")}')
            endif
        endfor
    endif
enddef
command ShowImage ShowImage()

# git diff
def GitDiffThisFile()
    var fname = resolve(expand('%:p'))
    var dirname = fname->fnamemodify(':p:h')
    exec $'!cd {dirname};git diff {fname}; cd -'
enddef
command GitDiffThisFile GitDiffThisFile()

def StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        :normal mz
        :normal Hmy
        :%s/\s\+$//e
        :normal 'yz<CR>
        :normal `z
    endif
enddef
command StripTrailingWhitespace StripTrailingWhitespace()

import autoload "text.vim"
command! -range FixSpaces text.FixSpaces(<line1>, <line2>)

# Wipe all unlisted buffers
def UnlistedBuffersWipe()
    var buffers = filter(getbufinfo(), (_, v) => v.unlisted)
    if !empty(buffers)
        execute 'confirm bwipeout' join(mapnew(buffers, (_, v) => v.bufnr))
    endif
enddef
command! UnlistedBuffersWipe UnlistedBuffersWipe()
