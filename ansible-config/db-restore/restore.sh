echo "[+] Downloading the backup"
mc cp pg/data/backups/postgres/"{{ backup_name }}" backup.sql.gz
gzip -d backup.sql.gz
echo "[+] Terminating all the active connections"
psql -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'waldur' AND pid <> pg_backend_pid();"
echo "[+] Dropping database"
psql -d postgres -c 'DROP DATABASE waldur;'
echo "[+] Creating a clean database"
createdb waldur
echo "[+] Applying the backup"
psql -f backup.sql > /dev/null
echo "[+] Removing the backup file"
rm backup.sql
