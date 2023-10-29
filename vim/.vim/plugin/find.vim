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
    var cmd = ['fd', '-tf', '-tl']
    if ctx[0] =~ '^/'
        cmd += [ '-p', '-g'] # can use **/foo
    endif
    return cmd->add($'{ctx[0]->shellescape()}')
enddef

def FoundSingleFile(context: string): bool
    def OutHandler(channel: channel, msg: string)
        echom 'handler ' .. msg
        if foundfile->empty()
            foundfile = msg
        else
            # vjob->job_stop('kill')
        endif
    enddef
    var start = reltime()
    foundfile = ''
    var lines = []
    # var job: job = job_start(GetCmd(context), {out_cb: 'OutHandler'})
    echom GetCmd(context)
    var job: job = job_start(GetCmd(context), {out_cb: (ch, str) => lines->add(str)})
    # ch_close_in(job)
    echom job->ch_status()
    while  (job->ch_status() !~# '^closed$\|^fail$' || job->job_status() ==# 'run')
            && start->reltime()->reltimefloat() * 1000 < 100
            :sleep 1m
    endwhile
    echom job->ch_status()
    echom job->job_status()
    if job->job_status() ==# 'run'
        job->job_stop('kill')
    endif
    echom 'foundfile ' .. foundfile
    echom lines
    return !foundfile->empty()
enddef

def CmdAutoComplete()
    var context = getcmdline()->strpart(0, getcmdpos() - 1)
    if context =~ '\v^Find\s+' && !wildmenumode()
        def RemoveFocus(_: number)
            if wildmenumode()
                feedkeys("\<s-tab>", 'tn')
            endif
        enddef
        if !FoundSingleFile(context)
            feedkeys("\<tab>", 'tn')
            timer_start(0, function(RemoveFocus))
        else
            # var found = FindProg('', context, 0)
            # if found->empty() && !foundfile->empty()
            if !foundfile->empty()
                popup_winid->popup_settext(foundfile)
                popup_winid->popup_show()
                :redraw
            endif
            # elseif found->len() > 1
            #     feedkeys("\<tab>", 'tn')
            #     timer_start(0, function(RemoveFocus))
            # endif
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
    # if found->len() == 1
    #     foundfile = found[0]
    #     return []
    # endif
    # foundfile = ''
    return found
enddef

