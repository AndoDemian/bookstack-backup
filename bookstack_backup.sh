#!/usr/bin/env bash

# Global vars
BACKUP_LOCATION="/opt/backup/"
LOG_NAME="bookstack_backup"

# Global functions
_logger() {
    local now=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$now: $@" | tee -a ${BACKUP_LOCATION}/${LOG_NAME}_$(date +%Y-%m-%d_%H-%M).log
}

_check_error() {
    if [[ $? -ne 0 ]]; then
        local ERROR_MESSAGE="$1"
        _logger "${ERROR_MESSAGE}"
    fi
}

# Let the backups begin !
_backup_database() {
    USER="USER"
    PASSWORD="PASS"
    HOST="HOST"
    DATABASE_NAME="bookstack"
    DUMP_ARGS="--force --no-tablespaces --no-autocommit --add_locks --disable_keys --extended-insert --quick --single-transaction"
    DUMP_NAME="bookstack_db_$(date +%Y-%m-%d_%H-%M).sql"

    export MYSQL_PWD="${PASSWORD}"
    mysqldump ${DUMP_ARGS} -u "${USER}" -h"${HOST}" "${DATABASE_NAME}" > "${BACKUP_LOCATION}"/"${DUMP_NAME}"
    _check_error "Error with the MySQL Dump!"

    if [[ -f "${BACKUP_LOCATION}"/"${DUMP_NAME}" ]]; then
        gzip "${BACKUP_LOCATION}"/"${DUMP_NAME}"
        _check_error "Error archiving the MySQL Dump!"
    fi
}

_backup_files() {
    HTML_PATH="/var/www/"
    HTML_FOLDER="bookstack"

    cd "${HTML_PATH}"
    tar -czf "${BACKUP_LOCATION}/bookstack_files_$(date +%Y-%m-%d_%H-%M).tar.gz" "${HTML_FOLDER}"
    _check_error "Error with the Files backup!"
}

_permissions() {
    find "${BACKUP_LOCATION}" -name "*.gz" -exec chmod 400 {} \;
}

_clean_up() {
    KEEP_DAYS=10
    find "${BACKUP_LOCATION}"  \( -name "*.gz" -o -name "*.log" \) -daystart -mtime +${KEEP_DAYS} -exec rm {} \;
}


_logger "Starting backup ..."
_logger "Backup database ..."
_backup_database
_logger "Backup Files ..."
_backup_files
_logger "Setting permissions ..."
_permissions
_logger "Cleaning up ..."
_clean_up
_logger "The script took $SECONDS seconds."
