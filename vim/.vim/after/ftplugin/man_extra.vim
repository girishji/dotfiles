vim9script

# needed by cppman shell command (uses vim as pager) and :Man
if &filetype == "man"
    # https://vi.stackexchange.com/questions/4302/how-can-i-show-tabs-as-spaces-instead-of-i-or-ctrl-i
    set listchars=tab:  
    b:undo_ftplugin ..= ' | set listchars<'
endif
