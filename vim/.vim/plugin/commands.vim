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

# Wipe all hidden buffers
def HiddenBuffersWipe()
    var buffers = filter(getbufinfo(), (_, v) => v.hidden)
    if !empty(buffers)
        execute 'confirm bwipeout' join(mapnew(buffers, (_, v) => v.bufnr))
    endif
enddef
command! HiddenBuffersWipe HiddenBuffersWipe()
