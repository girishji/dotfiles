vim9script

# Define 'Find' command

:set wildmenu wildoptions+=pum wildchar=<Tab> wildmode=full:lastused

# Find file without autosuggest. autosuggest searches twice (uses popup).
# Note:
# If there is only one completion item and <tab> is invoked automatically then
# <BS> will not work since it continuously completes the item. If there is
# only one item then create a popup menu.
var foundfile = ''
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
            setcmdline($'Find {foundfile}')
        elseif key ==? "\<tab>"
            setcmdline($'Find {foundfile}')
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

def GetContextComponents(context: string): list<string>
    var match = context->matchlist('\vFind\s+(\S+)?(\s+)?(\S+)?')
    return [match[1], match[3]]
enddef

def GetCmd(cmdline: string): list<string>
    var ctx = GetContextComponents(cmdline)
    if !ctx[0]->empty() && ctx[0] =~ '^/'
        return ['fd', '-tf', '-tl', '-p', $'{ctx[0]}']
    endif
    return ['fd', '-tf', '-tl', $'{ctx[0]}']
enddef

def IsLongDurationFind(context: string): bool
    var start = reltime()
    var vjob: job = job_start(GetCmd(context))
    while start->reltime()->reltimefloat() * 1000 < 100
        if vjob->job_status() ==? 'run'
            :sleep 5m
        else
            break
        endif
    endwhile
    if vjob->job_status() ==? 'run'
        vjob->job_stop('kill')
        return true
    endif
    return false
enddef

def CmdAutoComplete()
    var context = getcmdline()->strpart(0, getcmdpos() - 1)
    if context =~ '\v^Find\s+' && !wildmenumode()
        def RemoveFocus(_: number)
            feedkeys("\<s-tab>", 'tn')
        enddef
        if IsLongDurationFind(context)
            feedkeys("\<tab>", 'tn')
            timer_start(0, function(RemoveFocus))
        else
            var found = FindProg('', context, 0)
            if found->empty() && !foundfile->empty()
                popup_winid->popup_settext(foundfile)
                popup_winid->popup_show()
                :redraw
            elseif found->len() > 1
                feedkeys("\<tab>", 'tn')
                timer_start(0, function(RemoveFocus))
            endif
        endif
    endif
enddef

augroup CmdlineAutocmds | autocmd!
    autocmd CmdlineChanged : CmdAutoComplete()
augroup END

# Find file to edit using 'fd' shell command
command -nargs=1 -bang -complete=customlist,FindProg Find edit<bang> <args>
def FindProg(arglead: string, cmdline: string, cursorpos: number): list<string>
    var found = GetCmd(cmdline)->join()->systemlist()
    var ctx = GetContextComponents(cmdline)
    if !ctx[1]->empty()
        found->filter((_, v) => v =~# $'{ctx[1]}')
    endif
    if found->len() == 1
        foundfile = found[0]
        return []
    endif
    foundfile = ''
    return found
enddef

