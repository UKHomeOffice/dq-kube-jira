# Deploying JIRA in Docker on ACP

## Initial deployment

This project is expected to be used to deploy in the UK Home Office ACP and
therefore depends on certain features present in the platform.

## Introduction

This deployment will create 3 containers:-

* jira - To run the Atlassian JIRA product
* nginx - To act as a reverse proxy that sits in front of JIRA
* s3-backup - To backup JIRA & its database and push the backups to S3.

### Environment variables
The [UKHomeOffice/jira-docker](https://github.com/UKHomeOffice/jira-docker) image requires the following environment variables to be set as part of the deployment as they are used to set the server's proxy and database connections at runtime.

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

The [UKHomeOffice/dq-jira-s3-backup](https://github.com/UKHomeOffice/dq-jira-s3-backup) container (which is on by default in this repo) to backup JIRA to S3, the following environment variables will also need to be set:-

Environment variable  | Description | Example
--------------------- | ----------- | -------
BUCKET_NAME           | The S3 bucket to use for the backups | backup-bucket
AWS_ACCESS_KEY_ID     | The AWS key used to authenticate with the bucket | my_aws_key
AWS_SECRET_ACCESS_KEY | The secret key used to authenticate with the BUCKET_NAME | my_aws_secret_key

It is important to note that the [dq-jira-s3-backup](https://github.com/UKHomeOffice/dq-jira-s3-backup) image also requires `PGPASSWORD` to be set as an environment variable. In this deployment `DATABASE_PASSWORD` is presented to the container as `PGPASSWORD` using the same Kube secret so there is no need to set `PGPASSWORD` separately.

### Backing up data to S3

This deployment includes the [dq-jira-s3-backup](https://github.com/UKHomeOffice/dq-jira-s3-backup) container which takes periodic backups of JIRA and its database (PostgreSQL) and stores these in S3.

This deployment also provides a Kube volumeMount to both the JIRA and s3-bcakup containers which is required for the s3-backup image to work.

## Running JIRA for the 1st time

If this is the first time starting JIRA (fresh install) then follow the steps below

### 1. Set up the database

JIRA will not create a database for itself, so it must exist before running the online setup. So, JIRA requires that a database and a user are created that have the required permissions.

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

Customise the database creation for whichever database server/service you are using, but be sure to set the correct values in the `DATABASE_*` environmental variables.

### 2. Set the environment variables in Drone secrets

Using the [environmental variables](### Environment variables) section above, create the required environment variables as Drone secrets ready for deployment.

Note that there are two sets of variables, one for JIRA itself and another for the s3-backups.

### 3. Deploy

Now that the database and the environment variables are set up, it's time to deploy.

### 4. Set up JIRA

You will need to use the online setup tool to complete the installation of Jira. This should only need to be run once.
