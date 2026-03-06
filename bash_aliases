export EDITOR="vim"

alias ..='cd ..'
alias v='vim'

DOTFILE_DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
# install btrfs snapshot commands
alias snph="sudo ${DOTFILE_DIR}/snapshot.sh home"
alias snpr="sudo ${DOTFILE_DIR}/snapshot.sh root"

source ${DOTFILE_DIR}/git_bash_aliases

alias cdk='cd $(git root)/tools/testing/selftests/kvm'
alias cdl='cd $(git root)/tools/testing/selftests/liveupdate'
alias cdv='cd $(git root)/tools/testing/selftests/vfio'
alias ek='echo $KBUILD_OUTPUT'
alias lh='ls -lh'
alias lltr='ls -ltrF'
alias m='make'
alias mc='make cscope'
alias mca='ALLSOURCE_ARCHS=all make cscope'
alias mcl='make clean'
alias mdk='make defconfig kvm_guest.config'
alias mh='make help | less'
alias mj='make -j$(nproc) -s'
alias mja='make -j$(nproc) -s all'
alias mjb='make -j$(nproc) -s bzImage'
alias mjm='make -j$(nproc) -s modules'
alias mjv='make -j$(nproc) -s vmlinux'
alias mm='make menuconfig'
alias r='cd $(git root)'
alias tt='mutt'
alias v='vim'

function h2d() {
	if [[ "$#" -gt 1 ]]; then
		echo "Use as: h2d ffff"
		return 1
	fi

	echo $((16#"$1"))
}
function d2h() {
	if [[ "$#" -gt 1 ]]; then
		echo "Use as: d2h 1123"
		return 1
	fi

	echo "obase=16; $1"|bc
}

function li() {
	pushd $(git root)
	./scripts/clang-tools/gen_compile_commands.py
	cd tools/testing/selftests/kvm
	LLVM=1 make -Bnwk | compiledb --command-style -o- >> $(git root)/compile_commands.json
	cd ../vfio
	LLVM=1 make -Bnwk | compiledb --command-style -o- >> $(git root)/compile_commands.json
	cd $(git root)
	sed -i -z 's/\}\n\]\(\n\)\?\[/\},/g' compile_commands.json
	popd
}

function gwa() {
	if ! [[ $# -ne 2 ]]; then
		echo "Need branch and remote name"
	fi

	git worktree add -b "$1" ../"$1" "$2"
}

