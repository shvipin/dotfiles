export EDITOR="vim"

alias ..='cd ..'
alias v='vim'

DOTFILE_DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
# install btrfs snapshot commands
alias snph="sudo ${DOTFILE_DIR}/snapshot.sh home"
alias snpr="sudo ${DOTFILE_DIR}/snapshot.sh root"

source ${DOTFILE_DIR}/git_bash_aliases