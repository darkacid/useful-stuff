Modify USERNAME, PASSWORD, AllDB variables.

The script creates an autobackup folder and writes the compressed database dumps (specified by AllDB array) in it.

It is assumed that a user with the above credentials exists on server.

When creating this user on the server the following permissions must be allowed (SELECT, LOCK TABLES, SHOW VIEW, RELOAD, PROCESS).

Add the line from backupdb_time-crontab.conf file to the local user crontab ( by $ crontab -e ).

