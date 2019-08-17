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
  if [[ -d "${HOME}/.local/bin" ]]; then
    export PATH="${PATH}:${HOME}/.local/bin"
  fi

  # add go to path
  if [[ -d "${HOME}/go" ]]; then
    export GOPATH=$HOME/go
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
    kw() { watch -n 1 "kubectl $@"; }
    knodepods() { kubectl get pods --all-namespaces --field-selector spec.nodeName=$@; }
    alias kv="~/Projects/bitmovin-k8s/services/versions.sh"
    alias kpod="kubectl run jam-debug --rm -i --tty --image=ubuntu -- bash -li"
  fi

  if [[ -x $(which minikube) ]]; then
    source <(minikube completion bash)
  fi

fi # end interactive
