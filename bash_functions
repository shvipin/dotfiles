# Custom Helper Functions for Dotfiles

DOTFILE_DIR="${DOTFILE_DIR:-$(dirname $(realpath ${BASH_SOURCE[0]}))}"

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

function cds() {
	cd $(git root)/tools/testing/selftests/"${1:-""}"
}

function vdiff() {
    local file="$1"
    local dir="${2:-$VD_DIFF}" # Use arg 2, or fallback to VD_DIFF

    if [ -z "$file" ] || [ -z "$dir" ]; then
        echo "Usage: vdiff <filepath> [<directory>]"
        return 1
    fi

    vimdiff "$file" "${dir%/}/$file"
}

function mdk() {
	# Find the kernel root directory
	local kernel_root=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ -z "$kernel_root" ]]; then
		echo "Error: Not in a git repository (must be run inside kernel tree)."
		return 1
	fi

	# Determine the output directory (objtree)
	local objtree=""
	if [[ -n "$KBUILD_OUTPUT" ]]; then
		if [[ "$KBUILD_OUTPUT" = /* ]]; then
			objtree="$KBUILD_OUTPUT" # Absolute path
		else
			objtree="${kernel_root}/${KBUILD_OUTPUT}" # Relative path
		fi
	else
		objtree="$kernel_root"
	fi
	objtree=$(realpath "$objtree")

	# Hardcoded for x86 (assuming x86_64)
	local base_config="${kernel_root}/arch/x86/configs/x86_64_defconfig"
	local kvm_config="${kernel_root}/kernel/configs/kvm_guest.config"
	local configs=("$kvm_config")

	# Add MONOLITHIC config by default (built-in modules)
	local monolithic_cfg="${DOTFILE_DIR}/kconfig/MONOLITHIC.config"
	if [[ -f "$monolithic_cfg" ]]; then
		configs+=("$monolithic_cfg")
	else
		echo "Error: MONOLITHIC.config not found."
		return 1
	fi

	# Parse passed configs
	for cfg in "$@"; do
		local cfg_path="${DOTFILE_DIR}/kconfig/${cfg}.config"
		if [[ -f "$cfg_path" ]]; then
			configs+=("$cfg_path")
		elif [[ -f "$cfg" ]]; then
			configs+=("$cfg")
		else
			echo "Error: Config fragment '$cfg' not found."
			return 1
		fi
	done

	# Merge them
	echo "Merging config fragments: ${configs[*]} into base $base_config"
	local merge_args=()
	if [[ "$objtree" != "$kernel_root" ]]; then
		merge_args+=("-O" "$objtree")
	fi
	
	"$kernel_root/scripts/kconfig/merge_config.sh" "${merge_args[@]}" "$base_config" "${configs[@]}"
}

function skb() {
	# Find the kernel root directory
	local kernel_root=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ -z "$kernel_root" ]]; then
		echo "Error: Not in a git repository (must be run inside kernel tree)."
		return 1
	fi

	local target_dir=""
	if [[ -n "$1" ]]; then
		# Use passed directory path (resolve to absolute)
		target_dir=$(realpath "$1")
	else
		# Default to 'build' in git root
		target_dir="${kernel_root}/build"
	fi

	# Create directory if it doesn't exist
	if [[ ! -d "$target_dir" ]]; then
		echo "Creating build directory: $target_dir"
		mkdir -p "$target_dir"
	fi

	# Export KBUILD_OUTPUT
	export KBUILD_OUTPUT="$target_dir"
	echo "KBUILD_OUTPUT set to: $KBUILD_OUTPUT"
}

# Tab completion for mdk
_mdk_complete() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	# Dynamically list all config files in the kconfig directory, stripping '.config'
	local fragments=$(find "${DOTFILE_DIR}/kconfig" -name "*.config" -exec basename {} .config \;)

	COMPREPLY=( $(compgen -W "${fragments}" -- "$cur") )
}
complete -F _mdk_complete mdk

function upm() {
	local patchid="$1"
	local dest_name="$1"
	local dir_path="$HOME/upstream_linux"
	if ! [[ -n "$1" ]]; then
		echo "Patch id missing"
		return 1
	fi
	if [[ -n "$2" ]]; then
		dest_name="$2"
	fi
	if [[ ! -d "$dir_path"/"$dest_name" ]]; then
		mkdir -p "$dir_path"/"$dest_name"
	fi
	b4 mbox -C -o "$dir_path"/"$dest_name" "$patchid" -n "$patchid"
	if [[ ! -n "$3" ]]; then
		neomutt -d 5 -f "$dir_path"/"$dest_name"/"$patchid"
	fi
}

function upc() {
	local patchid="$1"
	local branch_name="$1"
	local dir_path="$HOME/upstream_linux"
	if ! [[ -n "$1" ]]; then
		echo "Patch id missing"
		return 1
	fi
	if [[ -n "$2" ]]; then
		branch_name="$2"
	fi
	if ! [[ -d "$dir_path"/"$branch_name" ]]; then
		mkdir -p "$dir_path"/"$branch_name"
	fi
	upm "$patchid" "$branch_name" 999
	cd $HOME/upstream_linux/linux || return 1
	if ! git worktree add -b "$branch_name" "../$branch_name/linux" linux-next/master; then
		echo "Error: Failed to create worktree."
		return 1
	fi

	# Setup out-of-tree build & direnv for new worktree
	mkdir -p "../$branch_name/linux/build"
	echo "export KBUILD_OUTPUT=build" > "../$branch_name/linux/.envrc"
	if type direnv &>/dev/null; then
		(cd "../$branch_name/linux" && direnv allow)
	fi

	cd "../$branch_name/linux" || return 1
	b4 shazam "$1"
}

