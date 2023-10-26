vim9script

# Define 'Find' command

# Find file without autosuggest. autosuggest searches twice (uses popup).
# Note:
# If there is only one completion item and <tab> is invoked automatically then
# <BS> will not work since it continuously completes the item.
:set wildmenu wildoptions+=pum wildchar=<Tab> wildmode=full:lastused
var foundfiles = ['foo', 'bar']
var attr = {
    cursorline: false, # Do not automatically select the first item
    pos: 'botleft',
    line: &lines - &cmdheight,
    col: len('Find ') + 1,
    drag: false,
    border: [0, 0, 0, 0],
    filtermode: 'c',
    minwidth: 14,
    hidden: true,
    filter: (winid, key) => {
        var retval = false
        if key ==? "\<cr>"
            setcmdline($'Find {foundfiles[0]}')
        elseif key ==? "\<tab>"
            setcmdline($'Find {foundfiles[0]}')
            retval = true
        endif
        winid->popup_hide()
        :redraw
        return retval
    },
    callback: (winid, result) => {
        if result == -1 # popup force closed due to <c-c>
            feedkeys("\<c-c>", 'n')
        endif
    },
}
var popup_winid = popup_menu([], attr)

def CmdAutoComplete()
    if !wildmenumode()
        var context = getcmdline()->strpart(0, getcmdpos() - 1)
        if context =~ '\v^Find\s+'
            if foundfiles->len() > 1
                feedkeys("\<tab>", 'tn')
                def RemoveFocus(timer: number)
                    feedkeys("\<s-tab>", 'tn')
                enddef
                timer_start(0, function(RemoveFocus))
            elseif foundfiles->len() == 1
                popup_winid->popup_settext(foundfiles)
                popup_winid->popup_show()
                :redraw
            endif
        endif
    endif
enddef

augroup CmdlineAutocmds | autocmd!
    autocmd CmdlineChanged : CmdAutoComplete()
augroup END

# Find file to edit using 'fd' shell command (ignores 'build', '.git' dirs)
command -nargs=1 -bang -complete=customlist,FindProg Find edit<bang> <args>
def FindProg(arglead: string, cmdline: string, cursorpos: number): list<string>
    foundfiles = systemlist('fd -tf -tl -g ' .. shellescape($"{arglead}*"))
    if foundfiles->empty()
        foundfiles = systemlist('fd -tf -tl -p ' .. shellescape($"{arglead}"))
    endif
    # If only one file is found wildmenu autocompletes it without showing
    # menu. We do not want that since <bs> will not work due to continuous autocompletion.
    return foundfiles->len() != 1 ? foundfiles : []
enddef
