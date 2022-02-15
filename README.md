# Bookstack - Backup script

Bash script to backup Bookstack (MySQL + Files).

---

## Installation

Download the script

```bash
wget https://raw.githubusercontent.com/AndoDemian/bookstack-backup/master/bookstack_backup.sh
chmod +x bookstack_backup.sh
```

Edit the variables

```bash
BACKUP_LOCATION="" # Path to backup location
USER=""            # MySQL User
PASSWORD=""        # MySQL Password
HOST=""            # MySQL Host
DATABASE_NAME=""   # Bookstack Database
HTML_PATH=""       # HTML Path before the bookstack folder
HTML_FOLDER=""     # HTML bookstack folder
```

---

## Authors

- [@AndoDemian](https://github.com/AndoDemian)
