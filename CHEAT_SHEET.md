# 🛠️ Dotfiles Cheat Sheet

This cheat sheet documents the custom scripts, aliases, and functions available in this dotfiles repository.

---

## 📋 Table of Contents
1. [Virtual Machine Management (Scripts)](#1-virtual-machine-management-scripts)
2. [Kernel Development & Make Aliases](#2-kernel-development--make-aliases)
3. [Git Shortcuts & Functions](#3-git-shortcuts--functions)
4. [General Navigation & Shell Utilities](#4-general-navigation--shell-utilities)
5. [Custom Helper Functions](#5-custom-helper-functions)
6. [Upstream Review Checklist](#-upstream-review-checklist)

---

## 1. Virtual Machine Management (Scripts)
These scripts are located in `scripts/` and are automatically added to your `PATH`. They are prefixed with `vs-` for easy tab-completion.

| Command | Description | Key Options |
| :--- | :--- | :--- |
| **`vs-create-vm`** | Creates a Debian unstable VM image using `debvm-create`. | `-n <name>` (default: `~/.local/share/vs-vm/deb_unstable.ext4`), `-s <size>` (default: `10G`), `-k <ssh_key_pub>` (default: `scripts/id_testvm_passwordless.pub`) |
| **`vs-run-vm`** | Boots the custom Debian VM image using QEMU (`debvm-run`). | `-i <image>` (default: `~/.local/share/vs-vm/deb_unstable.ext4`), `-h <dir>` (default: Git Root or CWD, use 'none' to disable), `-k <kernel>` (default: built bzImage from KBUILD_OUTPUT, use 'none' to boot guest kernel), `-m <modules>`, `-c <cpus>` (default: 4), `-r <ram>` (default: 16G), `-p <ssh_port>` (default: 2222), `-g <hugepages>`, `-t <iommu>` (intel/amd/none), `-a <boot_args>` |
| **`vs-ssh-vm`** | SSH into the running VM as root. | `-k <private_key>` (default: `scripts/id_testvm_passwordless`), `-p <port>` (default: 2222), `[command...]` (optional command to run) |
| **`vs-snapshot`** | Takes Btrfs snapshots of `root` or `home` subvolumes. | `[root\|home]` (requires sudo) |
| **`vs-sync-to-ai`** | Manages and syncs a parallel worktree (`ai_<branch>`) for AI assistants. | `-f` / `--force` (overwrite dirty files/commits) |
| **`vs-update-mbx`**| Updates a local mbox file with the latest thread from lore.kernel.org. | `<mbox-file>` |
| **`vs-help`** / **`dh`** / **`dothelp`** | Interactive search and view of this cheat sheet. | `[query]` (optional search query) |

---

## 2. Kernel Development & Make Aliases
These aliases make it easier to configure, build, and navigate the Linux Kernel source tree.

### Navigation
*   **`cdk`**: `cd` into KVM selftests directory (`tools/testing/selftests/kvm`).
*   **`cdl`**: `cd` into Liveupdate selftests directory (`tools/testing/selftests/liveupdate`).
*   **`cdv`**: `cd` into VFIO selftests directory (`tools/testing/selftests/vfio`).
*   **`cds [test_dir]`**: Quick navigation function to `tools/testing/selftests/[test_dir]`.
*   **`r`**: `cd` to the Git root directory of the kernel source.

### Build (`make`) Aliases
*   **`m`**: `make`
*   **`mj`**: `make -j$(nproc) -s` (Silent parallel build using all cores)
*   **`mja`**: `make -j$(nproc) -s all` (Build everything)
*   **`mjb`**: `make -j$(nproc) -s bzImage` (Build kernel image)
*   **`mjm`**: `make -j$(nproc) -s modules` (Build modules)
*   **`mjv`**: `make -j$(nproc) -s vmlinux` (Build vmlinux)
*   **`mcl`**: `make clean`
*   **`mm`**: `make menuconfig` (Configure kernel)
*   **`mdk [-m] [fragments...]`**: Configures guest kernel. Defaults to **built-in (monolithic)**. Use `-m` to keep it **modular**. Merges custom fragments from `kconfig/` (e.g., `mdk VFIO`, `mdk -m VFIO`).
    *   *Available fragments*: `DEBUG` (Symbols, BPF, Tracing, Printk Caller), `LOCKDEP` (Lock validator), `NET_PERF` (Devmem TCP, io_uring ZCRX), `VFIO` (VFIO/IOMMUFD, SR-IOV), `LIVEUPDATE` (DAX, PMEM, Kexec Handover/KHO, Live Update), `KVM_HOST` (KVM Hypervisor).
*   **`mh`**: `make help \| less` (Show make help)
*   **`ek`**: `echo $KBUILD_OUTPUT` (Show kernel build output directory)

### Code Indexing
*   **`mc`**: `make cscope` (Generate cscope index)
*   **`mca`**: `ALLSOURCE_ARCHS=all make cscope` (Generate cscope index for all architectures)
*   **`li`**: Custom function to generate `compile_commands.json` for KVM and VFIO selftests.

---

## 3. Git Shortcuts & Functions
Defined in `git_bash_aliases`. These shortcuts speed up common Git operations.

### Status & Diff
*   **`gs`**: `git status`
*   **`gd`**: `git diff`
*   **`gds`**: `git diff --staged`
*   **`gg <pattern>`**: `git grep -n <pattern>` (Grep in git tracked files)
*   **`gf`**: Open files with merge conflicts in your editor.

### Add & Commit
*   **`ga`**: `git add`
*   **`gaa`**: `git add -A` (Add all changes)
*   **`gau`**: `git add -u` (Add updated files)
*   **`gap`**: `git add -p` (Patch/interactive add)
*   **`gcs`**: `git commit -s` (Commit with sign-off)
*   **`gca`**: `git commit --amend`
*   **`gcas`**: `git commit --amend -s`
*   **`gcan`**: `git commit --amend --no-edit`
*   **`gcans`**: `git commit --amend --no-edit -s`

### Branch & Worktree
*   **`gb`**: `git branch`
*   **`gck`**: `git checkout`
*   **`gwa <branch_name>`**: Create a new git worktree at `../<branch_name>` with a new branch.

### History (Log)
*   **`gl`**: `git log`
*   **`gl1`**: `git log -1` (Show last commit)
*   **`glo`**: `git log` with a beautiful, compact, colored one-line format.
*   **`glg <pattern>`**: Search commit messages for pattern.
*   **`glp`**: `git log -p` (Show log with patches)
*   **`glpr`**: `git log -p --reverse`
*   **`gln`**: `git log --name-status` (List files changed in commits)
*   **`gln1`**: `git log --name-status -1`
*   **`gsh [HEAD~N]`**: `git show HEAD<N>` (e.g., `gsh ~1` shows `HEAD~1`)
*   **`gsha <commit>`**: `git show <commit>`

### Rebase & Cherry-pick
*   **`gpr`**: `git pull --rebase`
*   **`gr`**: `git rebase`
*   **`gra`**: `git rebase --abort`
*   **`grc`**: `git rebase --continue`
*   **`gri`**: `git rebase -i` (Interactive rebase)
*   **`gcp`**: `git cherry-pick`
*   **`gcpa`**: `git cherry-pick --abort`
*   **`gcpc`**: `git cherry-pick --continue`

### Stash & Cleanup
*   **`gst`**: `git stash`
*   **`gsa`**: `git stash apply`
*   **`gcln`**: `git clean -xdfq` (Forcefully clean untracked/ignored files)
*   **`grstf`**: `git reset --hard FETCH_HEAD`

---

## 4. General Navigation & Shell Utilities
*   **`..`**: `cd ..` (Go up one directory)
*   **`v`**: `vim` (Quick edit)
*   **`lh`**: `ls -lh` (Human readable list)
*   **`lltr`**: `ls -ltrF` (Sort by time, reverse, with file types)
*   **`cddot`**: `cd` into this dotfiles directory.
*   **`snph`**: `sudo vs-snapshot home` (Btrfs snapshot home)
*   **`snpr`**: `sudo vs-snapshot root` (Btrfs snapshot root)
*   **`tt`**: `mutt` (Quick open mutt mail client)

---

## 5. Custom Helper Functions

### Decimal & Hex Conversion
*   **`h2d <hex>`**: Converts a hexadecimal number to decimal. E.g., `h2d ffff`
*   **`d2h <dec>`**: Converts a decimal number to hexadecimal. E.g., `d2h 65535`

### Diff Helper
*   **`vdiff <filepath> [<directory>]`**: Runs `vimdiff` against a file in a different directory (defaults to `$VD_DIFF` if directory omitted). Useful for comparing local changes to upstream/downstream trees.

### Kernel Build Helper
*   **`skb [<path>]`**: Sets `KBUILD_OUTPUT` for consistent out-of-tree builds. Creates the directory if missing. Defaults to `[git_root]/build` in the current kernel tree.

### Upstream Review Helpers
*   **`upm <patch-id> [<dest_name>] [<skip_mutt>]`**: Downloads a patch series as mbox using `b4` and opens it in `neomutt`.
*   **`upc <patch-id> [<branch_name>]`**: Creates a git worktree, downloads the patch series, configures `direnv` (with `KBUILD_OUTPUT=build`), and applies the patches using `b4 shazam`.

---

## 📋 Upstream Review Checklist
A detailed step-by-step checklist for reviewing upstream patches is available in [upstream_review_checklist.md](file:///usr/local/google/home/vipinsh/work/git/shvipin/dotfiles/upstream_review_checklist.md).

