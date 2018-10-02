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

  # add go to path
  GOROOT="/opt/go"
  if [[ -d ${GOROOT} ]]; then
    export GOROOT
    export PATH="${PATH}:${GOROOT}/bin"
  fi
  GOPATH="$(go env GOPATH 2>/dev/null || '')"
  if [[ -d ${GOPATH} ]]; then
    export PATH="${PATH}:${GOPATH}/bin"
  fi

  # enable bash completion in interactive shells
  if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
      . /etc/bash_completion
  fi

  # enable cross env ssh-agent
  if [[ -z ${SSH_AUTH_SOCK} && -x $HOME/bin/xenv-ssh-agent.sh ]]; then
    . $HOME/bin/xenv-ssh-agent.sh
  fi
  
  # add gcloud
  if [[ -d "/opt/google-cloud-sdk/bin" ]]; then
    export PATH="${PATH}:/opt/google-cloud-sdk/bin"
  fi

  # bash completion for kubernetes
  if [[ -x $(which kubectl) ]]; then
    source <(kubectl completion bash)
    alias k=kubectl
  fi

fi # end interactive
