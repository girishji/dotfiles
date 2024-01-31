vim9script

# Credits:
#   https://github.com/habamax/.vim/blob/master/autoload/popup.vim#L89-L89
#   https://www.reddit.com/r/vim/comments/198rt3i/a_cool_piece_of_vimscript_to_navitate_userdefined/

var borderchars     = ['─', '│', '─', '│', '┌', '┐', '┘', '└']
# var borderchars     = ['≃', '╎', '≂', '╎', '╒', '╕', '╛', '╘']
var bordertitle     = ['─┐', '┌']
var borderhighlight = []
if hlexists('PopupBorderHighlight')
    borderhighlight = ['PopupBorderHighlight']
endif
var popuphighlight  = get(g:, "popuphighlight", 'Normal')
var popupscrollbarhighlight  = get(g:, "popupscrollbarhighlight", 'PmenuSbar')
var popupthumbhighlight  = get(g:, "popupthumbhighlight", 'PmenuThumb')

class FilterMenuPopup
    var _items: list<any>
    var _filtered_items: list<any>
    var _prompt: string = ''
    var _title: string
    var _items_dict: list<dict<any>>
    var _id: number

    def PopupCreate(title: string, items: list<any>, Callback: func(any, string), Setup: func(number), FilterItems: func(list<any>, string): list<any>, Colorize: func(list<any>): list<any>, close_on_bs: bool = false, is_hidden: bool = false)
        if empty(prop_type_get('FilterMenuMatch'))
            hi def link FilterMenuMatch Constant
            prop_type_add('FilterMenuMatch', {highlight: "FilterMenuMatch", override: true, priority: 1000, combine: true})
        endif

        this._title = title
        this._SetItems(items)
        var height = min([&lines - 6, max([this._items->len(), 5])])
        var minwidth = (&columns * 0.6)->float2nr()
        var pos_top = ((&lines - height) / 2) - 1
        var ignore_input = ["\<cursorhold>", "\<ignore>", "\<Nul>",
                    \ "\<LeftMouse>", "\<LeftRelease>", "\<LeftDrag>", $"\<2-LeftMouse>",
                    \ "\<RightMouse>", "\<RightRelease>", "\<RightDrag>", "\<2-RightMouse>",
                    \ "\<MiddleMouse>", "\<MiddleRelease>", "\<MiddleDrag>", "\<2-MiddleMouse>",
                    \ "\<MiddleMouse>", "\<MiddleRelease>", "\<MiddleDrag>", "\<2-MiddleMouse>",
                    \ "\<X1Mouse>", "\<X1Release>", "\<X1Drag>", "\<X2Mouse>", "\<X2Release>", "\<X2Drag>",
                    \ "\<ScrollWheelLeft", "\<ScrollWheelRight>"
        ]
        # this sequence of bytes are generated when left/right mouse is pressed and
        # mouse wheel is rolled
        var ignore_input_wtf = [128, 253, 100]
        var items_count = this._items->len()
        var winid = popup_create(Colorize(this._filtered_items), {
            title: $" ({items_count}/{items_count}) {this._title} {bordertitle[0]}  {bordertitle[1]}",
            line: pos_top,
            minwidth: minwidth,
            maxwidth: (&columns - 5),
            minheight: height,
            maxheight: height,
            border: [],
            borderchars: borderchars,
            borderhighlight: borderhighlight,
            highlight: popuphighlight,
            scrollbarhighlight: popupscrollbarhighlight,
            thumbhighlight: popupthumbhighlight,
            drag: 0,
            wrap: 1,
            cursorline: false,
            padding: [0, 1, 0, 1],
            mapping: 0,
            hidden: is_hidden,
            filter: (id, key) => {
                var new_minwidth = popup_getpos(id).core_width
                items_count = this._items->len()
                if new_minwidth > minwidth
                    minwidth = new_minwidth
                    popup_move(id, {minwidth: minwidth})
                endif
                if key == "\<esc>"
                    popup_close(id, -1)
                elseif ["\<cr>", "\<C-j>", "\<C-v>", "\<C-t>", "\<C-o>"]->index(key) > -1
                        && this._filtered_items[0]->len() > 0 && items_count > 0
                    popup_close(id, {idx: getcurpos(id)[1], key: key})
                elseif key == "\<Right>" || key == "\<PageDown>"
                    win_execute(id, 'normal! ' .. "\<C-d>")
                elseif key == "\<Left>" || key == "\<PageUp>"
                    win_execute(id, 'normal! ' .. "\<C-u>")
                elseif key == "\<tab>" || key == "\<C-n>" || key == "\<Down>" || key == "\<ScrollWheelDown>"
                    var ln = getcurpos(id)[1]
                    win_execute(id, "normal! j")
                    if ln == getcurpos(id)[1]
                        win_execute(id, "normal! gg")
                    endif
                elseif key == "\<S-tab>" || key == "\<C-p>" || key == "\<Up>" || key == "\<ScrollWheelUp>"
                    var ln = getcurpos(id)[1]
                    win_execute(id, "normal! k")
                    if ln == getcurpos(id)[1]
                        win_execute(id, "normal! G")
                    endif
                # Ignoring fancy events and double clicks, which are 6 char long: `<80><fc> <80><fd>.`
                elseif ignore_input->index(key) == -1 && strcharlen(key) != 6 && str2list(key) != ignore_input_wtf
                    if key == "\<C-U>"
                        this._prompt = ""
                        this._filtered_items = [this._items_dict]
                    elseif (key == "\<C-h>" || key == "\<bs>")
                        if empty(this._prompt) && close_on_bs
                            popup_close(id, {idx: getcurpos(id)[1], key: key})
                            return true
                        endif
                        this._prompt = this._prompt->strcharpart(0, this._prompt->strchars() - 1)
                        if empty(this._prompt)
                            this._filtered_items = [this._items_dict]
                        else
                            this._filtered_items = FilterItems(this._items_dict, this._prompt)
                        endif
                    elseif key =~ '\p'
                        this._prompt = this._prompt .. key
                        this._filtered_items = FilterItems(this._items_dict, this._prompt)
                    endif
                    popup_setoptions(id, {title: $" ({items_count > 0 ? this._filtered_items[0]->len() : 0}/{items_count}) {this._title} {bordertitle[0]} {this._prompt} {bordertitle[1]}" })
                    popup_settext(id, Colorize(this._filtered_items))
                endif
                return true
            },
            callback: (id, result) => {
                if result->type() == v:t_number
                    if result > 0
                        Callback(this._filtered_items[0][result - 1], "")
                    endif
                else
                    Callback(this._filtered_items[0][result.idx - 1], result.key)
                endif
            }
        })

        win_execute(winid, "setl nu cursorline cursorlineopt=both")
        if Setup != null_function
            Setup(winid)
        endif
        this._id = winid
    enddef

    def PopupSetText(items: list<any>,
            FilterItems: func(list<any>, string): list<any>,
            Colorize: func(list<any>): list<any> = null_function)
        if this.PopupClosed()
            return
        endif
        this._SetItems(items)
        var items_count = this._items->len()
        if empty(this._prompt)
            this._filtered_items = [this._items_dict]
        else
            this._filtered_items = FilterItems(this._items_dict, this._prompt)
        endif
        popup_setoptions(this._id, {title: $" ({items_count > 0 ? this._filtered_items[0]->len() : 0}/{items_count}) {this._title} {bordertitle[0]} {this._prompt} {bordertitle[1]}"})
        popup_settext(this._id, Colorize(this._filtered_items))
        if !this._id->popup_getpos()->get('visible', true)
            var height = min([&lines - 6, max([this._items->len(), 5])])
            var pos_top = ((&lines - height) / 2) - 1
            popup_setoptions(this._id, {minheight: height, maxheight: height, line: pos_top})
            this._id->popup_show()
            feedkeys("\<bs>", "nt")  # workaround for https://github.com/vim/vim/issues/13932
        endif
    enddef

    def PopupClosed(): bool
        return this._id->popup_getpos()->empty()
    enddef

    def _SetItems(items: list<any>)
        this._items = items
        var items_count = items->len()
        if items_count < 1
            this._items_dict = [{text: ""}]
        elseif items[0]->type() != v:t_dict
            this._items_dict = items->mapnew((_, v) => {
                return {text: v}
            })
        else
            this._items_dict = items
        endif
        this._filtered_items = [this._items_dict]
    enddef

endclass

def Printify(itemsAny: list<any>, props: list<any>): list<any>
    if itemsAny[0]->len() == 0 | return [] | endif
    if itemsAny->len() > 1
        return itemsAny[0]->mapnew((idx, v) => {
            return {text: v.text, props: itemsAny[1][idx]->mapnew((_, c) => {
                return {col: v.text->byteidx(c) + 1, length: 1, type: 'FilterMenuMatch'}
            }) + (props->empty() ? [] : props) + v->get('props', [])}
        })
    else
        return itemsAny[0]->mapnew((_, v) => {
            return props->empty() ? {text: v.text} : {text: v.text, props: props}
        })
    endif
enddef

# Popup menu with fuzzy filtering
export def FilterMenu(title: string, items: list<any>, Callback: func(any, string) = null_function, Setup: func(number) = null_function, FilterItems: func(list<any>, string): list<any> = null_function, close_on_bs: bool = false)
    var FilterFunc = FilterItems
    if FilterItems == null_function
        FilterFunc = (lst, prompt) => lst->matchfuzzypos(prompt, {key: "text"})
    endif
    var popup = FilterMenuPopup.new()
    popup.PopupCreate(title, items, Callback, Setup, FilterFunc,
        (lst) => Printify(lst, []),
        close_on_bs)
enddef

var job: job
# Popup menu with fuzzy filtering, using separate job to extract the menu list.
export def FilterMenuAsync(title: string,
        items_cmd: list<string>,
        Callback: func(any, string) = null_function,
        Setup: func(number) = null_function,
        ItemsPostProcess: func(list<any>): list<any> = null_function,
        FilterItems: func(list<any>, string): list<any> = null_function,
        Colorize: func(list<any>): list<any> = null_function,
        close_on_bs: bool = false)
    def BuildItemsList(cmd: list<string>, CallbackFn: func(list<any>))
        # ch_logfile('/tmp/channellog', 'w')
        # ch_log('BuildItemsList call')
        var start = reltime()
        var items = []
        if job->job_status() ==# 'run'
            job->job_stop('kill')
        endif
        job = job_start(cmd, {
            out_cb: (ch, str) => {
                items->add(str)
                if start->reltime()->reltimefloat() * 1000 > 100 # update every 100ms
                    CallbackFn(ItemsPostProcess == null_function ? items : ItemsPostProcess(items))
                    start = reltime()
                endif
            },
            exit_cb: (jb, status) => {
                CallbackFn(ItemsPostProcess == null_function ? items : ItemsPostProcess(items))
            }
        })
    enddef
    var popup = FilterMenuPopup.new()
    var FilterFunc = FilterItems
    if FilterItems == null_function
        FilterFunc = (lst, prompt) => lst->matchfuzzypos(prompt, {key: "text", limit: 100})
    endif
    var ColorizeFunc = Colorize
    if Colorize == null_function
        ColorizeFunc = (lst) => Printify(lst, [])
    endif
    popup.PopupCreate(title, [], Callback, Setup, FilterFunc, ColorizeFunc, close_on_bs, true)
    BuildItemsList(items_cmd, (items) => {
        if popup.PopupClosed()
            job->job_stop()
        endif
        popup.PopupSetText(items, FilterFunc, ColorizeFunc)
    })
enddef


# Returns winnr of created popup window
# export def ShowAtCursor(text: any, Setup: func(number) = null_function): number
#     var new_text = text
#     if text->type() == v:t_string
#         new_text = text->trim("\<CR>")
#     else
#         new_text = text->mapnew((_, v) => v->trim("\<CR>"))
#     endif
#     var winid = popup_atcursor(new_text, {
#         padding: [0, 1, 0, 1],
#         border: [],
#         borderchars: borderchars,
#         borderhighlight: borderhighlight,
#         highlight: popuphighlight,
#         pos: "botleft",
#         mapping: 0,
#         filter: (winid, key) => {
#             if key == "\<Space>"
#                 win_execute(winid, "normal! \<C-d>\<C-d>")
#                 return true
#             elseif key == "j"
#                 win_execute(winid, "normal! \<C-d>")
#                 return true
#             elseif key == "k"
#                 win_execute(winid, "normal! \<C-u>")
#                 return true
#             elseif key == "g"
#                 win_execute(winid, "normal! gg")
#                 return true
#             elseif key == "G"
#                 win_execute(winid, "normal! G")
#                 return true
#             endif
#             if key == "\<ESC>"
#                 popup_close(winid)
#                 return true
#             endif
#             return true
#         }
#     })
#     if Setup != null_function
#         Setup(winid)
#     endif
#     return winid
# enddef

