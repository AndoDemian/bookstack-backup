#!/usr/bin/env bash
#
# This script automates the backup of BookStack, including database
# and files, with cleanup and secure permission setting for the backups.
#
# Author: Ando Demian <andodemian@outlook.com>
# Version: 2.0
# Created: February 15, 2022
# License: MIT


# --- Global Configuration ---
# BACKUP_LOCATION: Path to store the backups.
BACKUP_LOCATION="/opt/backup"
LOG_FILE="${BACKUP_LOCATION}/bookstack_backup_$(date +%Y-%m-%d).log"
# Database credentials
DB_USER="USER"
DB_PASSWORD="PASS"
DB_HOST="HOST"
DB_NAME="bookstack"
# HTML_PATH: Path to the Bookstack installation directory.
HTML_PATH="/var/www"
HTML_FOLDER="bookstack"
# KEEP_DAYS: Number of days to retain backups. Older files will be deleted.
KEEP_DAYS=10

# --- Logging ---
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "${timestamp} [${level}] ${message}" | tee -a "${LOG_FILE}"
}

info() { log "INFO" "$1"; }
error() { log "ERROR" "$1"; exit 1; }
success() { log "SUCCESS" "$1"; }

# --- Helpers ---
ensure_backup_location() {
    if [[ ! -d "${BACKUP_LOCATION}" ]]; then
        mkdir -p "${BACKUP_LOCATION}" || error "Failed to create backup location: ${BACKUP_LOCATION}"
    fi
}

cleanup_old_backups() {
    info "Cleaning up backups older than ${KEEP_DAYS} days..."
    find "${BACKUP_LOCATION}" -type f \( -name "*.gz" -o -name "*.log" \) -mtime +${KEEP_DAYS} -exec rm {} \;
    success "Old backups cleaned up."
}

set_permissions() {
    info "Setting secure permissions for backup files..."
    find "${BACKUP_LOCATION}" -type f -name "*.gz" -exec chmod 400 {} \;
    success "Permissions set."
}

# --- Backup Functions ---
backup_database() {
    local dump_file="${BACKUP_LOCATION}/bookstack_db_$(date +%Y-%m-%d_%H-%M).sql.gz"

    info "Starting MySQL database backup..."
    export MYSQL_PWD="${DB_PASSWORD}"
    mysqldump --no-tablespaces --no-autocommit --add_locks --disable_keys \
              --extended-insert --quick --single-transaction \
              -u "${DB_USER}" -h "${DB_HOST}" "${DB_NAME}" | gzip > "${dump_file}" || error "Database backup failed."

    success "Database backup completed: ${dump_file}"
}

backup_files() {
    local archive_file="${BACKUP_LOCATION}/bookstack_files_$(date +%Y-%m-%d_%H-%M).tar.gz"

    info "Starting file backup..."
    tar -czf "${archive_file}" -C "${HTML_PATH}" "${HTML_FOLDER}" || error "File backup failed."

    success "File backup completed: ${archive_file}"
}

# --- Main Execution ---
main() {
    local start_time=$SECONDS
    ensure_backup_location
    info "Backup process started."

    backup_database
    backup_files
    set_permissions
    cleanup_old_backups

    local duration=$((SECONDS - start_time))
    success "Backup process completed in ${duration} seconds."
}

# --- Run Script ---
main "$@"