#!/bin/bash

# Conventions
# root snapshots are saved in mounted directory /mnt/@snapshots
# home snapshots are saved in mounted directory /mnt/@home_snapshots

set -euxo pipefail

ROOT="/"
ROOT_SNAPSHOT_MNT="/mnt/@snapshots"
BOOT="/boot/"
BOOT_COPY="/boot_copy/"

HOME="/home"
HOME_SNAPSHOT_MNT="/mnt/@home_snapshots"

verify_root() {
    if [[ $(id -u) -ne 0 ]]; then
        echo "Execute as sudo"
        exit 1
    fi
}

verify_mount() {
    mountpoint -q "$1"
    if ! mountpoint -q "$1"; then
        echo "Root snapshot directory not found at $1"
        exit 1
    fi
}

snapshot() {
    sudo btrfs subvolume snapshot -r "$1" "$2"
}

sync() {
    rsync -aAX --delete "$1" "$2"
}

take_root_snapshot() {
    verify_mount "${ROOT_SNAPSHOT_MNT}"

    local SNAPSHOT_NAME="$(date -Iminutes)"
    local SNAPSHOT_PATH="${ROOT_SNAPSHOT_MNT}"/"${SNAPSHOT_NAME}"


    sync "${BOOT}" "${BOOT_COPY}"
    snapshot "${ROOT}" "${SNAPSHOT_PATH}"
}

take_home_snapshot() {
    verify_mount "${HOME_SNAPSHOT_MNT}"

    local SNAPSHOT_NAME="$(date -Iminutes)"
    local SNAPSHOT_PATH="${HOME_SNAPSHOT_MNT}"/"${SNAPSHOT_NAME}"


    snapshot "${HOME}" "${SNAPSHOT_PATH}"
}

verify_root

case "${1:-}" in
    root)
        take_root_snapshot
        ;;
    home)
        take_home_snapshot
        ;;
    *)
        echo "Usage: sudo $0 [home|root]"
        exit 1
        ;;
esac