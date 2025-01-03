#!/bin/zsh

##
# completion system
#

# 1) When you’re not sure why you end up with some matches and not others, you can
# hit CTRL+x h (for help) before completing your command. It will display some
# information about what the completion system will do to complete your
# context.
# 2) You can run 'zstyle' in your shell to display the styles set in your current
# session as well as their patterns.

# Even though zsh-autocomplete plugin initializes the completion system (no
# need for 'compinit'), call it explicitly so that cache file can be located
# outside ~/.zsh

ZCACHEFILE=${XDG_DATA_HOME:=~/.local/share}/zsh/zcompdump
# Just in case: If the parent directory doesn't exist, create it.
[[ -d $ZCACHEFILE:h ]] ||
    mkdir -p $ZCACHEFILE:h

autoload -U compinit
compinit -d $ZCACHEFILE

# $ man zshall
# /Use of compinit
#  To speed up the running of compinit, it can be made to produce a dumped
# configuration that will be read in on future invocations; this is the
# default, but can be turned off by calling compinit with the option -D.  The
# dumped file is .zcompdump in the same directory as the startup files (i.e.
# $ZDOTDIR or $HOME); alternatively, an explicit file name can be given by
# `compinit -d dumpfile'.  The next invocation of compinit will read the
# dumped file instead of performing a full initialization.


# zsh by default does not include aliases in autocompletion. Call
# _expand_alias function through completion mechanism. It needs to appear
# before _complete. This will cause TAB to expand alias.
# defaults: https://github.com/marlonrichert/zsh-autocomplete/blob/main/Functions/Init/.autocomplete__config
# see https://thevaluable.dev/zsh-completion-guide-examples/
# 'completer': this is the zstyle you want to configure
# _foo, _bar are actual completors. The order matter: the completion system will
# try each of these completer one after the other. The completion stop when
# some matches are found or when the completer stop it by itself.
# builtin zstyle ':completion:*' completer \
#     _expand _expand_alias _complete _correct _approximate _complete:-fuzzy _prefix _ignored
builtin zstyle ':completion:*' completer \
    _expand _complete _correct _approximate _complete:-fuzzy _prefix _ignored

# git directories show up as ~[dir]. This is because of dynamic naming of dirs.
# During file name expansion, a ~[string] is provided to the
# zsh_directory_name() function which will eventually reply with a directory
# name (path).
# https://vincent.bernat.ch/en/blog/2015-zsh-directory-bookmarks
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Other-Directory-Functions
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Expansion

############################################################
## Blurb from https://thevaluable.dev/zsh-completion-guide-examples/
#
# To initialize the completion for the current Zsh session, you’ll need to call
# the function compinit.

# autoload -U compinit; compinit

# The autoload command load a file containing shell commands. To find this
# file, Zsh will look in the directories of the Zsh file search path, defined
# in the variable $fpath, and search a file called compinit.

# When compinit is found, its content will be loaded as a function. The
# function name will be the name of the file. You can then call this function
# like any other shell function.

# Why using autoload, and not sourcing the file by doing source
# ~/path/of/compinit?

# - It avoids name conflicts if you have an executable with the same name.
# - It doesn’t expand aliases thanks to the -U option.
# - It will load the function only when it’s needed (lazy-loading). It comes in
#   handy to speed up Zsh startup.

# This line will complete dotfiles.
_comp_options+=(globdots) # With hidden files

## How Does the Zsh Completion System Work

# When you type a command in Zsh and hit the TAB key, a completion is attempted
# depending on the context. This context includes:

# - What command and options have been already typed at the command-line prompt.
# - Where the cursor is.

# The context is then given to one or more completer functions which will attempt
# to complete what you’ve typed. Each of these completers are tried in order and,
# if the first one can’t complete the context, the next one will try. When the
#     context can be completed, some possible matches will be displayed and you
#     can choose whatever you want.

#     A warning is thrown if none of the completers are able to match the
#     context.

#     There are two more things to know about completers:

#     The names of completers are prefixed with an underscore, like _complete or
#     _expand_alias for example. A few completers return a special value 0 which
#     will stop the completion, even if more completers are defined afterward.
#     Configuring Zsh Completion With zstyle

## Configure many aspects of the completion system using the zsh module zstyle

# Modules are part of Zsh but optional, detached from the core of the shell. They
# can be linked to the shell at build time or dynamically linked while the shell
# is running. Modules are written in C. You can use zmodload to load a module.

## What’s zstyle?

# You can think of zstyle as a  flexible way to modify the default settings of
# Zsh scripts (modules, widgets, functions, and so on). The authors of these
# scripts need to define what are these settings, what pattern a user can use to
# modify them, and how these modifications can affect their code.

# Here’s the general way you can use zstyle to configure a Zsh module:

# zstyle <pattern> <style> <values>

# The pattern act as a namespace. It’s divided by colons : and each value between
# these colons have a precise meaning.

# In the case of the Zsh completion system, the context we saw earlier (what
# you’ve already typed in your command-line) is compared with this pattern. If
# there’s a match, the style will be applied.

# man zshcompsys - Search for “Standard Styles”

## General zstyle Patterns for Completion

# To configure the completion system, you can use zstyle patterns following
# this template:

# :completion:<function>:<completer>:<command>:<argument>:<tag>

# The substring separated with colons : are called components. Let’s look at
# the ones used for the completion system in details:

# completion - String acting as a namespace, to avoid pattern collisions with other scripts also using zstyle.
# <function> - Apply the style to the completion of an external function or widget.
# <completer> - Apply the style to a specific completer. We need to drop the underscore from the completer’s name here.
# <command> - Apply the style to a specific command, like cd, rm, or sed for example.
# <argument> - Apply the style to the nth option or the nth argument. It’s not available for many styles.
# <tag> - Apply the style to a specific tag.

# You can think of a tag as a type of match. For example “files”, “domains”,
# “users”, or “options” are tags.

# You don’t have to define every component of the pattern. Instead, you can
# replace each of them with a star *. The more specific the pattern will be,
# the more precedence it will have over less specific patterns. For example:

# zstyle ':completion:*:*:cp:*' file-sort size
# zstyle ':completion:*' file-sort modification

# What happens if you set these styles?

# If you hit TAB after typing cp, the possible files matched by the completion
# system will be ordered by size.
# When you match files using the completion, they will be ordered by date of
# modification.
# The pattern :completion:*:*:cp:* has precedence over :completion:* because
# it’s considered more precise.

# The * replace any character including the colon :. That’s why the pattern
# :completion:*:*:cp:* is equivalent to :completion:*:cp:*.

# More here: https://thevaluable.dev/zsh-completion-guide-examples/
