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

### 2. Set the server's environment variables in Drone secrets

The image requires the following environment variables to be set as part of the deployment as they are used to set the server's proxy and database connections at runtime.

Environment variable | Description | Example
-------------------- | ----------- | -------
SERVER_PORT          | The port that the JIRA container is listening on | 8080
SERVER_REDIRECT_PORT | The port that the proxy container is listening on | 10443
SERVER_PROXY_NAME    | The host name of the proxy | jira.example.com
SERVER_PROXY_PORT    | The external port on the proxy | 443
DATABASE_HOST        | Database server host name  | db.example.com
DATABASE_PORT        | Database server port | 5432
DATABASE_NAME        | Database name | jiradb
DATABASE_USERNAME    | Database username | jira
DATABASE_PASSWORD    | Database user's password | supersecret
DATABASE_SCHEMA_NAME | Database schema name | public

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
