if !has('vim9script') ||  v:version < 900
    echoe "Needs Vim version 9.0 and above"
    finish
endif

vim9script

# Live 'Find', 'Grep', Buffer, and 'Keymap'.

var findcmd = 'fd -tf'
if exepath('fd')->empty()
    findcmd = 'find . -type f'
endif
var grepcmd = 'ag --vimgrep --smart-case'
if exepath('ag')->empty()
    grepcmd = 'grep -n --recursive'
endif

var findname = 'Find'
var grepname = 'Grep'
var kmapname = 'Keymap'
var bufcmdname = 'Buffer'

var items: list<string> = []
var index: number = 0
var winid: number
var processed: bool

def GetAttr(cmdname: string): dict<any>
    return {
        cursorline: false, # Do not automatically select the first item
        pos: 'botleft',
        line: &lines - &cmdheight,
        col: len(cmdname) + 2,
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
                if cmdname == findname
                    setcmdline($'edit {winbufnr(id)->getbufoneline(index + 1)}')
                elseif cmdname == grepname
                    var line = winbufnr(id)->getbufoneline(index + 1)
                    if cmdname =~ 'grep'
                        var match = line->matchlist('\v(.*):(\d+):')
                        setcmdline($'edit +{match[2]} {match[1]}')
                    else
                        var match = line->matchlist('\v(.*):(\d+):(\d+):')
                        setcmdline($'edit +call\ cursor({match[2]},{match[3]}) {match[1]}')
                    endif
                elseif cmdname == bufcmdname
                    var bufnr = winbufnr(id)->getbufoneline(index + 1)->matchstr('\v^\s*\zs\d+\ze')
                    setcmdline($'buffer {bufnr}')
                endif
                processed = false
            else
                winid->popup_hide()
                :redraw
                processed = false
            endif
            return processed
        },
        callback: (id, result) => {
            if result == -1 # popup force closed due to <c-c>
                feedkeys("\<c-c>", 'n')
            endif
        },
    }
enddef

def UpdatePopup(lines: list<string>, cmdname: string)
    if winid->popup_getoptions() == {}
        winid = popup_menu([], GetAttr(cmdname))
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


def BuildList(cmd: list<string>, cmdname: string)
    var start = reltime()
    items = []
    var job: job = job_start(cmd, {out_cb: (ch, str) => items->add(str)})
    var timeout = 2000 # ms
    while (job->ch_status() !~# '^closed$\|^fail$' || job->job_status() ==# 'run')
            && start->reltime()->reltimefloat() * 1000 < timeout
            :sleep 5m
            UpdatePopup(items, cmdname)
    endwhile
    if job->job_status() ==# 'run'
        job->job_stop('kill')
    endif
    UpdatePopup(items, cmdname)
enddef

def FindProg(cmdline: string)
    var match = cmdline->matchlist($'\v({findname})!?\s+(\S+)?(\s+)?(\S+)?(\s+)?(\S+)?')
    if match->empty()
        return
    endif
    if match[2]->empty()
        BuildList(findcmd->split(), findname)
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
            try
                lines = items->copy()->filter((_, v) => v =~ $'{match[2]}')
                for idx in [4, 6]
                    if !match[idx]->empty()
                        lines->filter((_, v) => v =~ $'{match[idx]}')
                    endif
                endfor
            catch
            endtry
        endif
        UpdatePopup(lines, findname)
    endif
enddef


def GrepProg(cmdline: string)
    var match = cmdline->matchlist($'\v({grepname})!?\s+(\S+)?(\s+)?(\S+)?(\s+)?(\S+)?(\s+)?(\S+)?')
    if match->empty()
        return
    endif
    if match[2]->empty()
        items = []
    elseif !match[3]->empty()
        if match[4]->empty()
            BuildList(grepcmd->split()->add(match[2]), grepname)
        else
            var lines = items->copy()
            for idx in [4, 6, 8]
                if !match[idx]->empty()
                    try
                        lines->filter((_, v) => v->matchstr('\v.*:\d+:\zs.*') =~ $'{match[idx]}')
                    catch
                    endtry
                endif
            endfor
            UpdatePopup(lines, grepname)
        endif
    endif
enddef

def KeymapProg(cmdline: string)
    var match = cmdline->matchlist($'\v({kmapname})!?\s+(\S+)?')
    if match->empty()
        return
    endif
    if match[2]->empty()
        items = execute('map')->split("\n")
        UpdatePopup(items, kmapname)
    else
        try
            var lines = items->copy()->filter((_, v) => v =~ $'{match[2]}')
            UpdatePopup(lines, kmapname)
        catch
        endtry
    endif
enddef


def BufferProg(cmdline: string)
    var match = cmdline->matchlist($'\v({bufcmdname})!?\s+(\S+)?')
    if match->empty()
        return
    endif
    if match[2]->empty()
        items = execute('ls!')->split("\n")
        UpdatePopup(items, bufcmdname)
    else
        try
            var lines = items->copy()->filter((_, v) => v =~ $'{match[2]}')
            UpdatePopup(lines, bufcmdname)
        catch
        endtry
    endif
enddef


def Fuzzy()
    if processed || wildmenumode()
        return
    endif
    var cmdline = getcmdline()->strpart(0, getcmdpos() - 1)
    if cmdline =~ $'\v^{findname}\s+'
        FindProg(cmdline)
    elseif cmdline =~ $'\v^{grepname}\s+'
        GrepProg(cmdline)
    elseif cmdline =~ $'\v^{kmapname}\s+'
        KeymapProg(cmdline)
    elseif cmdline =~ $'\v^{bufcmdname}\s+'
        BufferProg(cmdline)
    endif
enddef

var auto_suggest_setup_done = false
def Setup()
    processed = false
    if !auto_suggest_setup_done
        auto_suggest_setup_done = true
        if exists('*g:AutoSuggestSetup')
            var ignore = [$'^{findname}', $'^{grepname}', '^{kmapname}', '^{bufcmdname}']
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
    autocmd CmdlineChanged : Fuzzy()
    autocmd CmdlineLeave : Teardown()
augroup END
