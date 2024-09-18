#!/bin/zsh

##
# Commands and funtions
#

# This lets you change to any dir without having to type `cd`, that is, by just
# typing its name. Be warned, though: This can misfire if there exists an alias,
# function, builtin or command with the same name.
# In general, I would recommend you use only the following without `cd`:
#   ..  to go one dir up
#   ~   to go to your home dir
#   ~-2 to go to the 2nd mostly recently visited dir
#   /   to go to the root dir
setopt AUTO_CD

# Load zprof so that shell startup can be profiled.
# See https://www.bigbinary.com/blog/zsh-profiling
# zmodload zsh/zprof

# Set $PAGER if it hasn't been set yet. We need it below.
# `:` is a builtin command that does nothing and returns 0 as exit status.
# ex: (';' is statement terminator)
# > : foobar; echo hello
# > hello
#
# We use ':' here to stop Zsh from
# evaluating the value of our $expansion as a command.
# for ':=' see 'conditional substitutions' (https://zsh.sourceforge.io/Guide/zshguide05.html)
# `${param:=value}' is similar to the previous type. but in this case the shell
# will not only substitute value into the line, it will assign it to param if
# (and only if) it does so. This leads to the following common idiom in scripts
# and functions:
#
#  : ${MYPARAM:=default}  ${OTHERPARAM:=otherdefault}
#
# If the user has already set $MYPARAM, nothing happens, otherwise it will be
# set to `default', and similarly for ${OTHERPARAM}. The `:' command does
# nothing but return true after the command line has been processed.
: ${PAGER:=less}

# Use `< file` to quickly view the contents of any text file.
READNULLCMD=$PAGER  # Set the program to use for this.
