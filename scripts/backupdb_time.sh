
mkdir -p autobackup
USERNAME=root
PASSWORD=
DBNAME=

mysqldump -u$USERNAME -p$PASSWORD $DBNAME |gzip > autobackup/$DBNAME-$(date +"%F_%H:%M").sql.gz
find autobackup -name "*.sql.gz" -type f -mtime +15 -exec rm -f {} \;
echo Finished backup at $(date +"%F_%H:%M")

