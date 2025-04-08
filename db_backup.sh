
---

### File: db_backup.sh

```bash
#!/bin/bash
#
# db_backup.sh: A script to perform MySQL backup and restore operations.
#
# This script is structured in a modular way with separate functions for logging,
# backing up the database, and restoring the database. Each function is designed
# to perform a single task, which makes the code easier to maintain and understand.
#
# Usage:
#   ./db_backup.sh backup
#   ./db_backup.sh restore <backup_file.sql>
#

# -----------------------------------------------------------------------------
# Configuration: Set these variables to match your MySQL environment.
# -----------------------------------------------------------------------------
MYSQL_USER="your_username"
MYSQL_PASSWORD="your_password"
MYSQL_HOST="localhost"
MYSQL_DATABASE="your_database"

# Directory to store backup files.
BACKUP_DIR="./backups"
# Log file to record all operations.
LOG_FILE="db_backup.log"

# -----------------------------------------------------------------------------
# Ensure that the backup directory exists.
# -----------------------------------------------------------------------------
mkdir -p "$BACKUP_DIR"

# -----------------------------------------------------------------------------
# Function: log_message
# Purpose: Logs messages with timestamps to both console and log file.
# Input: A string message.
# -----------------------------------------------------------------------------
log_message() {
  local message="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - ${message}" | tee -a "$LOG_FILE"
}

# -----------------------------------------------------------------------------
# Function: backup_database
# Purpose: Backs up the specified MySQL database using mysqldump.
# Process:
#   - Creates a timestamped filename.
#   - Runs the mysqldump command and saves output to the backup file.
#   - Logs the success or failure of the operation.
# -----------------------------------------------------------------------------
backup_database() {
  # Create a timestamp for a unique backup file name.
  local TIMESTAMP
  TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
  local BACKUP_FILE="${BACKUP_DIR}/${MYSQL_DATABASE}_${TIMESTAMP}.sql"

  log_message "Starting backup for database '${MYSQL_DATABASE}'..."

  # Execute mysqldump and redirect output to the backup file.
  if mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" "$MYSQL_DATABASE" > "$BACKUP_FILE"; then
    log_message "Backup successful: ${BACKUP_FILE}"
  else
    log_message "Backup failed!"
    exit 1
  fi
}

# -----------------------------------------------------------------------------
# Function: restore_database
# Purpose: Restores the MySQL database from a given backup file.
# Input: The first parameter is the path to the backup file.
# Process:
#   - Checks if the backup file exists.
#   - Uses the mysql command to restore the database.
#   - Logs the success or failure of the restoration.
# -----------------------------------------------------------------------------
restore_database() {
  local BACKUP_FILE="$1"

  # Check if the provided backup file exists.
  if [ ! -f "$BACKUP_FILE" ]; then
    log_message "Restore failed: File '${BACKUP_FILE}' does not exist."
    exit 1
  fi

  log_message "Starting restoration for database '${MYSQL_DATABASE}' from '${BACKUP_FILE}'..."

  # Execute the mysql command to restore the backup.
  if mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" "$MYSQL_DATABASE" < "$BACKUP_FILE"; then
    log_message "Restore successful from ${BACKUP_FILE}"
  else
    log_message "Restore failed!"
    exit 1
  fi
}

# -----------------------------------------------------------------------------
# Main Logic: Processes command-line arguments to call the appropriate functions.
#
# The script supports two primary operations:
#   - 'backup': Triggers the backup_database function.
#   - 'restore': Expects a second argument for the backup file path and calls restore_database.
# -----------------------------------------------------------------------------
case "$1" in
  backup)
    backup_database
    ;;
  restore)
    if [ -z "$2" ]; then
      echo "Usage: $0 restore <backup_file.sql>"
      exit 1
    fi
    restore_database "$2"
    ;;
  *)
    # Display usage message if incorrect arguments are provided.
    echo "Usage: $0 {backup|restore <backup_file.sql>}"
    exit 1
    ;;
esac
