if !has('vim9script') ||  v:version < 900
    echoe "Needs Vim version 9.0 and above"
    finish
endif

vim9script

# 'Find', 'Grep', 'Buffer', and 'Keymap' commands for live 'fuzzy' search.
#
# USAGE:
#   :Find /start_of_line [regex]+
#   :Find start_of_line/foo/bar [regex]+
#   :Find start_of_file [regex]+
#   :Grep pat [regex_for_file_content]+
#   :Grep pat /start_of_line [regex_for_file_content]+
#   :Buffer [regex_for_file_name]+
#   :Keymap [regex]+
#
# NOTE: In regex, .* is greedy while .\{-} is non-greedy (:h non-greedy)

var findcmd = 'fd -tf'
if exepath('fd')->empty()
    findcmd = 'find . -type f'
endif
var grepcmd = 'ag --vimgrep --smart-case'
if exepath('ag')->empty()
    grepcmd = 'grep -n --recursive'
endif

var findcmdname = 'Find'
var grepcmdname = 'Grep'
var kmapcmdname = 'Keymap'
var bufcmdname = 'Buffer'

var currentcmdname: string

var items: list<string> = []
var index: number = 0
var winid: number
var processed: bool


def GetAttr(): dict<any>

    def ProcessTabKey(id: number, key: string)
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
    enddef

    def ProcessCarriageReturn(id: number, key: string)
        if currentcmdname == findcmdname
            setcmdline($'edit {winbufnr(id)->getbufoneline(index + 1)}')
        elseif currentcmdname == grepcmdname
            var line = winbufnr(id)->getbufoneline(index + 1)
            if currentcmdname =~ 'grep'
                var match = line->matchlist('\v(.*):(\d+):')
                setcmdline($'edit +{match[2]} {match[1]}')
            else
                var match = line->matchlist('\v(.*):(\d+):(\d+):')
                setcmdline($'edit +call\ cursor({match[2]},{match[3]}) {match[1]}')
            endif
        elseif currentcmdname == bufcmdname
            var bufnr = winbufnr(id)->getbufoneline(index + 1)->matchstr('\v^\s*\zs\d+\ze')
            setcmdline($'buffer {bufnr}')
        endif
        processed = false
    enddef

    def Filter(id: number, key: string): bool
        if key ==? "\<tab>" || key ==? "\<s-tab>"
            ProcessTabKey(id, key)
        elseif key ==? "\<cr>"
            ProcessCarriageReturn(id, key)
        else
            winid->popup_hide()
            :redraw
            processed = false
        endif
        return processed
    enddef

    return {
        cursorline: false, # Do not automatically select the first item
        pos: 'botleft',
        line: &lines - &cmdheight,
        col: 1,
        drag: false,
        border: [0, 0, 0, 0],
        filtermode: 'c',
        minwidth: 14,
        hidden: true,
        filter: function(Filter),
        callback: (id, result) => {
            if result == -1 # popup force closed due to <c-c>
                feedkeys("\<c-c>", 'n')
            endif
        },
    }
enddef


def UpdatePopup(lines: list<string>)
    if winid->popup_getoptions() == {}
        winid = popup_menu([], GetAttr())
    endif
    winid->popup_setoptions({cursorline: false})
    index = 0
    if !lines->empty()
        winid->popup_settext(lines)
        winid->popup_show()
    else
        winid->popup_hide()
        processed = false
    endif
    :redraw
enddef


def BuildList(cmd: list<string>)
    var start = reltime()
    items = []
    var job: job = job_start(cmd, {out_cb: (ch, str) => items->add(str)})
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


def FindProg(cmdline: string)
    var match = cmdline->matchlist($'\v({findcmdname})!?\s+(\S+)?(\s+)?(\S+)?(\s+)?(\S+)?')
    if match->empty()
        return
    endif
    if match[2]->empty()
        BuildList(findcmd->split())
    else
        var lines: list<string>
        try
            # Non greedy regex and glob is PITA. Just use '/' to search path
            # Instead of .* use .\{-} for non-greedy search. glob2regpat will convert glob to regex. # :h non-greedy
            if match[3]->empty() && match[2] !~ '/' # search only file names, not full path
                # lines = items->copy()->filter((_, v) => v->fnamemodify(':t') =~ $'^{match[2]}')
                lines = items->copy()->filter((_, v) => v->fnamemodify(':t') =~ $'{match[2]}')
            else
                if match[2] =~ '/'
                    var pat = match[2] =~ '^/' ? match[2]->slice(1) : match[2]
                    lines = items->copy()->filter((_, v) => v =~ $'^{pat}')
                else
                    lines = items->copy()->filter((_, v) => v =~ $'{match[2]}')
                endif
                for idx in [4, 6]
                    if !match[idx]->empty()
                        lines->filter((_, v) => v =~ $'{match[idx]}')
                    endif
                endfor
            endif
        catch
        endtry
        UpdatePopup(lines)
    endif
enddef


def GrepProg(cmdline: string)
    var match = cmdline->matchlist($'\v({grepcmdname})!?\s+(\S+)?(\s+)?(\S+)?(\s+)?(\S+)?(\s+)?(\S+)?')
    if match->empty()
        return
    endif
    if match[2]->empty()
        items = []
    elseif !match[3]->empty()
        if match[4]->empty()
            BuildList(grepcmd->split()->add(match[2]))
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
            UpdatePopup(lines)
        endif
    endif
enddef


def KeymapProg(cmdline: string)
    var match = cmdline->matchlist($'\v({kmapcmdname})!?\s+(\S+)?')
    if match->empty()
        return
    endif
    if match[2]->empty()
        items = execute('map')->split("\n")
        UpdatePopup(items)
    else
        var lines: list<string>
        try
            lines = items->copy()->filter((_, v) => v =~ $'{match[2]}')
        catch
        endtry
        UpdatePopup(lines)
    endif
enddef


def BufferProg(cmdline: string)
    var match = cmdline->matchlist($'\v({bufcmdname})!?\s+(\S+)?')
    if match->empty()
        return
    endif
    if match[2]->empty()
        items = execute('ls!')->split("\n")
        items->filter((_, v) => v->matchstr('".*"') !~ '\[Popup\]') # filter buffer of active popup
        UpdatePopup(items)
    else
        var lines: list<string>
        try
            if match[2] !~ '/' # search only file names, not full path
                lines = items->copy()->filter((_, v) => v->matchstr('".*"')->fnamemodify(':t') =~ $'{match[2]}')
                if lines->empty()
                    lines = items->copy()->filter((_, v) => v->matchstr('".*"') =~ $'{match[2]}')
                endif
            else
                var pat = match[2] =~ '^/' ? match[2]->slice(1) : match[2]
                lines = items->copy()->filter((_, v) => v->matchstr('".*"') =~ $'{match[2]}')
            endif
        catch
        endtry
        UpdatePopup(lines)
    endif
enddef


def Fuzzy()
    if processed || wildmenumode()
        return
    endif
    var cmdline = getcmdline()->strpart(0, getcmdpos() - 1)
    if cmdline =~ $'\v^{findcmdname}\s+'
        currentcmdname = findcmdname
        FindProg(cmdline)
    elseif cmdline =~ $'\v^{grepcmdname}\s+'
        currentcmdname = grepcmdname
        GrepProg(cmdline)
    elseif cmdline =~ $'\v^{kmapcmdname}\s+'
        currentcmdname = kmapcmdname
        KeymapProg(cmdline)
    elseif cmdline =~ $'\v^{bufcmdname}\s+'
        currentcmdname = bufcmdname
        BufferProg(cmdline)
    endif
enddef


def Setup()
    processed = false
    if exists('*g:AutoSuggestSetup')
        var ignore = [findcmdname, grepcmdname, kmapcmdname, bufcmdname]
        ignore->map((_, v) => $'^{v}')
        if exists('*g:AutoSuggestGetOptions')
            var opts = g:AutoSuggestGetOptions()
            ignore->extend(opts.cmd.exclude)
        endif
        g:AutoSuggestSetup({cmd: {exclude: ignore}})
    endif
enddef


def Teardown()
    if winid->popup_getoptions() != {}
        winid->popup_close()
    endif
enddef


augroup FindCmdAutocmds | autocmd!
    autocmd VimEnter * Setup()
    autocmd CmdlineChanged : Fuzzy()
    autocmd CmdlineLeave : Teardown()
augroup END
