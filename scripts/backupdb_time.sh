mkdir -p autobackup
USERNAME=backup
PASSWORD=''
AllDB=( db1 db2 )

set -o pipefail
for DBNAME in "${AllDB[@]}"
do
mysqldump -u$USERNAME -p$PASSWORD $DBNAME | gzip > autobackup/$DBNAME-$(date +"%F_%H:%M").sql.gz && \
echo Finished backup of $DBNAME at $(date +"%F_%H:%M")
done
if [ $? -eq 0 ];then
find autobackup -name "*.sql.gz" -type f -mtime +15 -exec rm -f {} \;
echo "Deleting old files"
fi