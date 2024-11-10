vim9script

command CscopeDB SetupCscope()
def SetupCscope()
    if filereadable('./cscope.out')
        cscope add ./cscope.out
    elseif filereadable('./../cscope.out')
        cscope add ./../cscope.out
    elseif filereadable(expand('~/cscope/cscope.out'))
        cscope add ~/cscope/cscope.out
    endif
enddef

# Find highlight group under cursor
command HighlightGroupUnderCursor {
    if exists("*synstack")
        for grp in synstack(line('.'), col('.'))->mapnew('synIDattr(v:val, "name")')
            echo 'Group:' grp
            var g = grp
            while true
                var linksto = $'hi {g}'->execute()->matchstr('links to \zs\S\+')
                if linksto == null_string
                    exec 'hi' g
                    break
                else
                    echo '->' linksto
                    g = linksto
                endif
            endwhile
        endfor
    endif
}

# Toggle folding of all folds in buffer (zR, zM)
command FoldingToggle FoldingToggle()
var myfoldingtoggleflag = false
def FoldingToggle()
    exec myfoldingtoggleflag ? 'normal! zR' : 'normal! zM'
    myfoldingtoggleflag = !myfoldingtoggleflag
enddef

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
command ShowImage ShowImage()
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

# git diff
command GitDiffThisFile GitDiffThisFile()
def GitDiffThisFile()
    var fname = resolve(expand('%:p'))
    var dirname = fname->fnamemodify(':p:h')
    exec $'!cd {dirname};git diff {fname}; cd -'
enddef

command TrailingWhitespaceStrip TrailingWhitespaceStrip()
def TrailingWhitespaceStrip()
    if !&binary && &filetype != 'diff'
        :normal mz
        :normal Hmy
        :%s/\s\+$//e
        :normal 'yz<CR>
        :normal `z
    endif
enddef

# Wipe all unlisted buffers
command! UnlistedBuffersWipe UnlistedBuffersWipe()
def UnlistedBuffersWipe()
    var buffers = filter(getbufinfo(), (_, v) => v.unlisted)
    if !empty(buffers)
        execute 'confirm bwipeout' join(mapnew(buffers, (_, v) => v.bufnr))
    endif
enddef

# :<range>Align [char]
command! -range -nargs=* Align Align(<line1>, <line2>, <f-args>)
def Align(line1: number, line2: number, delimit = null_string)
    var lines = getline(line1, line2)->mapnew((_, v) => v->split((delimit ?? '\s') .. '\+'))
    var maxwords = max(lines->mapnew((_, v) => v->len()))
    var maxcount = range(maxwords)->mapnew((_, i) =>
        lines->reduce((mc, line) => max([mc, i < line->len() ? line[i]->len() : 0]), 0))
    var indent = getline(line1, line2)->mapnew((_, v) => v->matchstr('\s*\ze\S*'))
    foreach(lines, (lnum, lwords) => {
        var line = range(max([0, lwords->len() - 1]))->reduce((s, j) =>
            $'{s}{lwords[j]}{repeat(" ", maxcount[j] - lwords[j]->len() + 1)}' ..
            (delimit != '' ? $'{delimit} ' : ''), '')
        line ..= lwords->empty() ? '' : lwords[-1]
        $'{indent[lnum]}{line}'->setline(line1 + lnum)
    })
enddef
