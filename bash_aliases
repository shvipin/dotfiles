export EDITOR="vim"

alias ..='cd ..'
alias v='vim'

DOTFILE_DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
export PATH="$DOTFILE_DIR/scripts:$PATH"

# install btrfs snapshot commands
alias snph="sudo ${DOTFILE_DIR}/scripts/vs-snapshot home"
alias snpr="sudo ${DOTFILE_DIR}/scripts/vs-snapshot root"

source ${DOTFILE_DIR}/git_bash_aliases

alias cdot='cd ${DOTFILE_DIR}'
alias dh='vs-help'
alias cdk='cd $(git root)/tools/testing/selftests/kvm'
alias cdl='cd $(git root)/tools/testing/selftests/liveupdate'
alias cdv='cd $(git root)/tools/testing/selftests/vfio'
alias ek='echo KBUILD_OUTPUT=$KBUILD_OUTPUT'
alias lh='ls -lh'
alias lltr='ls -ltrF'
alias m='make'
alias mc='make cscope'
alias mca='ALLSOURCE_ARCHS=all make cscope'
alias mcl='make clean'
alias mh='make help | less'
alias mj='make -j$(nproc) -s'
alias mja='make -j$(nproc) -s all'
alias mjb='make -j$(nproc) -s bzImage'
alias mjm='make -j$(nproc) -s modules'
alias mjv='make -j$(nproc) -s vmlinux'
alias mm='make menuconfig'
alias mo='make -j$(nproc) olddefconfig'
alias n=neomutt
alias r='cd $(git root)'
alias v='vim'

source ${DOTFILE_DIR}/bash_functions
