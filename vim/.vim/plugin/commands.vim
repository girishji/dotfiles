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

# Open files in ~/help folder
command -nargs=1 -complete=custom,<SID>Completor HelpFile OpenHelpFile(<f-args>)

def Completor(prefix: string, line: string, cursorpos: number): string
    var dir = '~/help'->expand()
    return dir->readdir((v) => !$'{dir}/{v}'->isdirectory() && v !~ '^\.')->join("\n")
enddef

def OpenHelpFile(prefix: string)
    var fname = $'~/help/{prefix}'
    if fname->expand()->filereadable()
        :exec $'edit {fname}'
    else  # if only item is showing in the popup menu, open it.
        var paths = fname->getcompletion('file')
        if paths->len() == 1
            :exec $'edit {paths[0]}'
        endif
    endif
enddef

def CanExpandHF(): bool
    if getcmdtype() == ':'
        var context = getcmdline()->strpart(0, getcmdpos() - 1)
        if context == 'hf'
            return true
        endif
    endif
    return false
enddef

cabbr <expr> hf <SID>CanExpandHF() ? 'HelpFile' : 'hf'

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

def TrailingWhitespaceStrip()
    if !&binary && &filetype != 'diff'
        :normal mz
        :normal Hmy
        :%s/\s\+$//e
        :normal 'yz<CR>
        :normal `z
    endif
enddef
command TrailingWhitespaceStrip TrailingWhitespaceStrip()

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
