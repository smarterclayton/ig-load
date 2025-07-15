bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

shopt -s histappend
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTCONTROL=ignoreboth
shopt -s cmdhist

export GREP_COLORS='mt=1;32;40'

export PATH=${GOPATH}/bin:/root/bin:${PATH}

export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1