# Deploying JIRA in Docker on ACP

## Initial deployment

This project is expected to be used to deploy in the UK Home Office ACP and
therefore depends on certain features present in the platform.

### 1. Set up the database_name

JIRA will not create a database for itself, so it must exist before running the online setup.

Connect to the database server:

```
psql -h $DBHOST -p $DBPORT -U $DBUSER $DBNAME
```

Then run the following two commands to create the database and grant the jira service user the required privileges:

```
CREATE DATABASE <database name> WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
GRANT ALL PRIVILEGES ON DATABASE <database name> TO <role name>;
```

### 2. Set the server's connection settings to work with the proxy

To get JIRA to work correctly with the proxy, the `server.xml` file needs to be
overwritten with the version in this repository. To do this deploy the container
and use `kubectl cp` to transfer the file on to the running container.

```
kubectl cp jira-conf/<env>/server.xml <jira pod id>:/opt/atlassian/jira/conf/server.xml -c jira
```

Restart the JIRA docker container to make JIRA pick up the new configuration:

```
kubectl delete pod <jira pod id>
```

### 3. Set up JIRA

Use the online setup.

## Maintenance

### Backing up data to S3

The image includes the AWS CLI tools so that data can be backed up to S3.

The `BUCKET_NAME` must be in the environment variables already and the server must have its AWS configuration set.

```
export BACKUP_DAY=$(date +%Y%m%d)
export BACKUP_TIME=$(date +%Y%m%d-%H%M)

tar -czvf $BACKUP_TIME-avatars.tar.gz /var/atlassian/jira/data/avatars
tar -czvf $BACKUP_TIME-attachments.tar.gz /var/atlassian/jira/data/attachments

aws s3 cp $BACKUP_TIME-avatars.tar.gz s3://$BUCKET_NAME/$BACKUP_DAY/$BACKUP_TIME-avatars.tar.gz
aws s3 cp $BACKUP_TIME-avatars.tar.gz s3://$BUCKET_NAME/$BACKUP_DAY/$BACKUP_TIME-attachments.tar.gz

```
