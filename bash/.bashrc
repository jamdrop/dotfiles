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
  export EMAIL="jam@jammm.eu.org"

  PS1='\u@\h# '
  
  HISTCONTROL=ignoreboth
  HISTSIZE=10000
  HISTFILESIZE=20000
  HISTTIMEFORMAT='%c '
  shopt -s histappend
  shopt -s checkwinsize

  eval "`dircolors -b`"
  alias ls='ls --color=auto -F'

  # add own scripts to path
  if [[ -d "${HOME}/bin" ]]; then
    export PATH="${PATH}:${HOME}/bin"
  fi

  # enable bash completion in interactive shells
  if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
      . /etc/bash_completion
  fi

  # enable cross env ssh-agent
  if [[ -x $(which dbus-launch) && -x $(which gnome-keyring-daemon) && -z ${DBUS_SESSIONBUS_ADDRESS} ]]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
    export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)
  elif [[ -x $HOME/bin/xenv-ssh-agent.sh ]]; then
    . $HOME/bin/xenv-ssh-agent.sh
  fi

fi # end interactive
