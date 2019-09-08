#!/usr/bin/env bash

usage() {
    echo "usage: $(basename "${0}") set level" >&2
}

cleanup_old_backups() {
    local set_name="${backup_name}-set${backup_set}"
    local set_base="${backup_base}/${set_name}"
    local lvl0_file="${set_base}-level0.dump.gz"

    find "${backup_base}" \
        -not -newer "${lvl0_file}" \
        -not -path "${lvl0_file}" \
        -name "${set_name}*" \
        -exec rm -rf '{}' ';'
}

create_new_backup() {
    local backup_destination="${backup_base}/${backup_name}-set${backup_set}-level${backup_level}.dump.gz"
    local backup_command="/sbin/dump -h0 -b64 -C16 -a -L -u -f - -${backup_level} -D /etc/dumpdates.set${backup_set} /"

    echo "COMMAND: ${backup_command}" >&2
    echo "DESTINATION: ${backup_destination}" >&2

    $backup_command | /usr/bin/gzip -4 > "${backup_destination}"
}

set -eu
pushd / 1>/dev/null 2>&1

if (( ${#} != 2 )); then
    usage
    exit 1
fi

backup_set="${1}"
backup_level="${2}"
backup_name="beastie"
backup_base="/var/backups/external"

cleanup_old_backups

create_new_backup

cleanup_old_backups
