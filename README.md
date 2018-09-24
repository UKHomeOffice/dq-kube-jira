# Deploying JIRA in Docker on ACP

## Initial deployment

This project is expected to be used to deploy in the UK Home Office ACP and
therefore depends on certain features present in the platform.

## Introduction

This deployment creates 3 containers:-

* JIRA - To run the Atlassian JIRA product
* nginx - To act as a reverse proxy that sits in front of JIRA
* s3-backup - To backup JIRA & its database and push the backups to S3.

### 1. Set up the database_name

JIRA will not create a database for itself, so it must exist before running the online setup.

The below example shows how to create a database when using PostgreSQL:-

* Connect to the database server

```
psql -h $DBHOST -p $DBPORT -U $DBUSER $DBNAME
```

* Run the following two commands to create the database and grant the JIRA service user the required privileges:

```
CREATE DATABASE <database name> WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
GRANT ALL PRIVILEGES ON DATABASE <database name> TO <role name>;
```

Customise the database creation for whichever database server/service you are using.

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

If using the [UKHomeOffice/dq-jira-s3-backup](https://github.com/UKHomeOffice/dq-jira-s3-backup) container (which is on by default in this repo) to backup JIRA to S3, the following environment variables will also need to be set:-

Environment variable  | Description | Example
--------------------- | ----------- | -------
BUCKET_NAME           | The S3 bucket to use for the backups | backup-bucket
AWS_ACCESS_KEY_ID     | The AWS key used to authenticate with the bucket | my_aws_key
AWS_SECRET_ACCESS_KEY | The secret key used to authenticate with the BUCKET_NAME | my_aws_secret_key

It is important to note that the [dq-jira-s3-backup](https://github.com/UKHomeOffice/dq-jira-s3-backup) image also requires `PGPASSWORD` to be set as an environment variable. In [this](https://github.com/UKHomeOffice/dq-kube-jira) deployment `DATABASE_PASSWORD` is presented to the container as `PGPASSWORD` using the same Kube secret.

### 3. Set up JIRA

If you are deploying Jira for the first time, you will need to use the online setup tool to complete the installation of Jira. This should only need to be run once.

## Maintenance

### Backing up data to S3

This deployment includes the [dq-jira-s3-backup](https://github.com/UKHomeOffice/dq-jira-s3-backup) container which takes periodic backups of JIRA and its database (PostgreSQL) and stores these in S3.

This deployment provides a Kube volumeMount to both the JIRA container and the s3-bcakup container which is required for the s3-backup container to work. At the time of writing the backups are set to run at 6AM and 6PM every day.
