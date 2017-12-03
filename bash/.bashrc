# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
if [[ -n "$PS1" ]]; then

  export LANG=de_AT.UTF-8
  export LC_ALL=de_AT.UTF-8
  export PAGER=less
  export EDITOR=vim
  export NAME="Jakob Mayring"
  export EMAIL="jakob.mayring@counity.at"

  PS1='\u@\h# '

  eval "`dircolors -b`"
  alias ls='ls --color=auto -F'

  alias iccenv.11.1='source /opt/intel/Compiler/11.1/073/bin/iccvars.sh intel64'
  alias iccvars='source ~/bin/iccvars.env'
  alias tomatoenv='source /opt/brcm/brcm.sh'
  alias xrandr-home="xrandr --output DVI-0 --mode 1680x1050 --right-of LVDS"

  if [[ -d "${HOME}/bin" ]]; then
    export PATH="${PATH}:${HOME}/bin"
  fi

  HISTCONTROL=ignoreboth
  HISTSIZE=5000
  HISTFILESIZE=5000
  HISTTIMEFORMAT='%c '

  shopt -s histappend

  # enable bash completion in interactive shells
  if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
      . /etc/bash_completion
  fi

  # enable cross env ssh-agent
  if [[ -x ~/bin/xenv-ssh-agent.sh ]]; then
    . ~/bin/xenv-ssh-agent.sh
  fi

fi # end interactive
