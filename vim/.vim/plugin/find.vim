vim9script

# 'Find' command

# :set wildmenu wildoptions+=pum wildchar=<Tab> wildmode=full:lastused

# Find file without autosuggest. autosuggest searches twice (uses popup).
# Note:
# If there is only one completion item and <tab> is invoked automatically then
# <BS> will not work since it continuously completes the item. If there is
# only one item then create a popup menu.
# var foundfile = ''


var findcmd = 'fd -tf'
if exepath('fd')->empty()
    findcmd = 'find . -type f'
endif
var items: list<string> = []
var index: number = 0
var cmdline: string
var winid: number
var processed: bool
var cmdstr = 'Find'
# var context: list<string>

# def GetContext(): list<string>
#     var match = cmdline->matchlist('\vFind\s+(\S+)?(\s+)?(\S+)?')
#     return [match[1], match[3]]
# enddef


# select next/prev item in popup menu; wrap around at end of list.
# def SelectItem(direction: string)
#     var count = items->len()
#     def selectvert()
#         if winid->popup_getoptions().cursorline
#             winid->popup_filter_menu(direction)
#             index += (direction ==# 'j' ? 1 : -1)
#             index %= count
#         else
#             winid->popup_setoptions({cursorline: true})
#             index = 0
#         endif
#     enddef

# enddef

var attr = {
    cursorline: false, # Do not automatically select the first item
    pos: 'botleft',
    line: &lines - &cmdheight,
    col: len(cmdstr) + 2,
    drag: false,
    border: [0, 0, 0, 0],
    filtermode: 'c',
    minwidth: 14,
    hidden: true,
    filter: (id, key) => {
        if key ==? "\<tab>" || key ==? "\<s-tab>"
            if id->popup_getoptions().cursorline
                var forward = key ==? "\<tab>"
                id->popup_filter_menu(forward ? 'j' : 'k')
                index += (forward ? 1 : -1)
            else
                id->popup_setoptions({cursorline: true})
            endif
            processed = true
            var count = line('$', id)
            if index < 0
                index = count - 1
                id->popup_setoptions({cursorline: false})
            elseif index > (count - 1)
                index = 0
                id->popup_setoptions({cursorline: false})
            endif
            :redraw
        elseif key ==? "\<cr>"
            setcmdline($'{cmdstr} {winbufnr(id)->getbufoneline(index + 1)}')
            processed = false
        else
            winid->popup_hide()
            :redraw
            # return !UpdatePopupMenu(key)
            processed = false
        endif
        return processed
        # return true
        # var retval = false
        # if key ==? "\<cr>"
        #     setcmdline($'Find {foundfile}')
        # elseif key ==? "\<tab>"
        #     setcmdline($'Find {foundfile}')
        #     retval = true
        # endif
        # winid->popup_hide()
        # :redraw
        # return retval
    },
    callback: (id, result) => {
        if result == -1 # popup force closed due to <c-c>
            feedkeys("\<c-c>", 'n')
        endif
    },
}

def UpdatePopup(lines: list<string>)
    if winid->popup_getoptions() == {}
        winid = popup_menu([], attr)
    endif
    winid->popup_setoptions({cursorline: false})
    index = 0
    if !lines->empty()
        winid->popup_settext(lines)
        winid->popup_show()
    else
        winid->popup_hide()
    endif
    :redraw
enddef


# var winid: number
# def Setup()
#     winid = popup_menu([], attr)
# enddef

# def UpdatePopupMenu()
#     var ctx = GetContext()
#     if !ctx[1]->empty() && (ctx[0] =~ '/' || ctx[0] =~ '*')

#     endif
#     if !ctx[1]->empty()
#         found->filter((_, v) => v =~# $'{ctx[1]}')
#     endif
#     if found->len() == 1
#         foundfile = found[0]
#         return []
#     endif


# enddef

# def GetCmd(cmdline: string, shellescape: bool = true): list<string>
# def GetCmd(ctx: string): list<string>
#     var cmd = ['fd', '-tf', '-tl']
#     if ctx =~ '/'
#         cmd->add('-p')
#     endif
#     if ctx =~ '*'
#         cmd->add( '-g') # can use **/foo
#     endif
#     return ctx->empty() ? cmd : cmd->add(ctx)
#     # return shellescape ? cmd->add($'{ctx[0]->shellescape()}') : cmd->add(ctx[0])
# enddef

def BuildFileList(context: string = '')
    var start = reltime()
    # var job = job_start(GetCmd(context), {out_cb: (ch, str) => OutHandler(str)})
    items = []
    # var job: job = job_start(GetCmd(context), {out_cb: (ch, str) => items->add(str)})
    var job: job = job_start(findcmd, {out_cb: (ch, str) => items->add(str)})
    var timeout = 2000 # ms
    while (job->ch_status() !~# '^closed$\|^fail$' || job->job_status() ==# 'run')
            && start->reltime()->reltimefloat() * 1000 < timeout
            :sleep 5m
            UpdatePopup(items)
    endwhile
    if job->job_status() ==# 'run'
        job->job_stop('kill')
    endif
    UpdatePopup(items)
enddef

def FindProg()
    cmdline = getcmdline()->strpart(0, getcmdpos() - 1)
    if cmdline !~ '\v^Find\s+' || processed || wildmenumode()
        return
    endif
    # var match = cmdline->matchlist('\v(Find)\s+(\S+)?(\s+)?(\S+)?')
    var match = cmdline->matchlist($'\v({cmdstr})\s+(\S+)?(\s+)?(\S+)?(\s+)?(\S+)?')
    # if !winid->popup_getpos()->get('visible', false)
    #     winid->popup_setoptions({cursorline: false})
    # endif
    if match[2]->empty()
        BuildFileList()
    else
        var lines: list<string>
        # Non greedy regex and glob is PITA. Just use '/' to search path
        # Instead of .* use .\{-} for non-greedy search. glob2regpat will convert glob to regex. # :h non-greedy
        if match[3]->empty() && match[2] !~ '/' # search only file names, not full path
            try
                lines = items->copy()->filter((_, v) => fnamemodify(v, ':t') =~ $'^{match[2]}')
            catch
            endtry
        else
            # def GetPattern(str: string): string
            #     if str =~ '*'
            #         var pat = glob2regpat(str)
            #         echom '---'
            #         echom pat
            #         pat = str->substitute('[*]', '\\{-}', 'g')
            #         echom pat
            #         return pat
            #     endif
            #     return str
            # enddef
            try
                lines = items->copy()->filter((_, v) => v =~ $'{match[2]}')
                if !match[4]->empty()
                    lines->filter((_, v) => v =~ $'{match[4]}')
                endif
                if !match[6]->empty()
                    lines->filter((_, v) => v =~ $'{match[6]}')
                endif
            catch
            endtry
        endif
        UpdatePopup(lines)
    endif
enddef

var auto_suggest_setup_done = false
def Setup()
    if !auto_suggest_setup_done
        auto_suggest_setup_done = true
        if exists('*g:AutoSuggestSetup')
            var ignore = [$'^{cmdstr}']
            if exists('*g:AutoSuggestGetOptions')
                var opts = g:AutoSuggestGetOptions()
                ignore->extend(opts.cmd.exclude)
            endif
            g:AutoSuggestSetup({cmd: {exclude: ignore}})
        endif
    endif
enddef

def Teardown()
    if winid->popup_getoptions() != {}
        winid->popup_close()
    endif
enddef


augroup FindCmdAutocmds | autocmd!
    autocmd CmdlineEnter : Setup()
    autocmd CmdlineChanged : FindProg()
    autocmd CmdlineLeave : Teardown()
augroup END
# augroup CmdlineAutocmds | autocmd!
#     autocmd CmdlineChanged : CmdAutoComplete()
# augroup END

command -nargs=1 -bang Find edit<bang> <args>

# Find file to edit using 'fd' shell command
# command -nargs=1 -bang -complete=customlist,FindProg Find edit<bang> <args>
# def FindProg(arglead: string, cmdline: string, cursorpos: number): list<string>
#     var found = GetCmd(cmdline)->join()->systemlist()
#     var ctx = GetContextComponents(cmdline)
#     if !ctx[1]->empty()
#         found->filter((_, v) => v =~# $'{ctx[1]}')
#     endif
#     if found->len() == 1
#         foundfile = found[0]
#         return []
#     endif
#     foundfile = ''
#     return found
# enddef

# fdf -p 'uni.*/un.*/c'
