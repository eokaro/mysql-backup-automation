# MySQL Backup and Restore Script

This repository contains a Bash script that provides basic functionality to backup and restore a MySQL database. The script is designed as a learning tool and a portfolio project to demonstrate your ability to automate system tasks using Bash, along with logging, error handling, and modular design.

## Overview

The `db_backup.sh` script has two primary functions:

- **Backup**: Uses `mysqldump` to export your MySQL database into a timestamped SQL file.
- **Restore**: Uses the `mysql` client to restore a given SQL backup into your MySQL database.

## Key Components and Their Functions

- **Configuration Variables**: At the top of the script, variables like `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_HOST`, `MYSQL_DATABASE`, `BACKUP_DIR`, and `LOG_FILE` are defined. These allow you to easily adjust the script to match your environment without changing the logic.
- **Logging Function**: The `log_message` function logs every operation with a timestamp. This makes it easier to troubleshoot or understand the sequence of events.
- **Backup Function**: The `backup_database` function creates a timestamped backup file. It uses `mysqldump` to dump the database and logs the success or failure of this operation.
- **Restore Function**: The `restore_database` function takes a backup file as an argument and restores the database using the `mysql` command-line tool. It also performs basic error checking (e.g., ensuring the backup file exists).
- **Main Program Flow**: The script checks command-line arguments to determine whether to execute a backup or restoration. This structure allows the same script to be used in different contexts, such as scheduling with cron or integrating with job schedulers like AutoSys.

## Setup and Usage

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name

