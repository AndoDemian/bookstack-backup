# Bookstack - Backup script

A Bash script to back up BookStack, including MySQL database and optional file backups.

---

## Installation

### 1. Download the Script

Run the following commands to download and set up the script:

```bash
wget https://raw.githubusercontent.com/AndoDemian/bookstack-backup/main/bookstack_backup.sh
chmod +x bookstack_backup.sh
```

### 2. Edit the Configuration Variables

```bash
BACKUP_LOCATION=""    # Path to the backup location
DB_USER=""            # MySQL User
DB_PASSWORD=""        # MySQL Password
DB_HOST=""            # MySQL Host
DB_NAME=""            # BookStack Database
HTML_PATH=""          # Path before the BookStack folder
HTML_FOLDER=""        # BookStack folder name
KEEP_DAYS=10          # Number of days to retain old backups (Default 10)
```

---

## Usage

### 1. Run the script:

```bash
./bookstack_backup.sh
```

### 2. Automate backups by adding a cron job:

```bash
0 2 * * * /path/to/bookstack_backup.sh >> /path/to/backup/backup_cron.log 2>&1
```

> This example runs the backup daily at 2:00 AM and logs the output to backup_cron.log.

---

## Features

- Backs up the MySQL database in compressed format.
- Optionally backs up BookStack files for a complete restore.
- Automatically cleans up old backups older than KEEP_DAYS.
- Logs all operations for troubleshooting and auditing.
- Ensures secure permissions for backup files.

---

## Authors

[@AndoDemian](https://github.com/AndoDemian)

---

## License

This project is licensed under the MIT License.
