# dq-jira-s3-backup

## Introduction
This image is designed to work alongside the `UKHomeOffice/jira-docker` image, providing periodic backups of `Jira` to `S3`.

The image is available in a public repo on Quay:-
https://quay.io/repository/ukhomeofficedigital/dq-jira-s3-backup

## Prerequisites
* Jira is running in a separate container.
* A volume exists which is available to both containers.
* Both containers have a volumeMount in Kubernetes mounted at /var/atlassian/jira/.

## Environment Variables
The image requires the following environment variables to be set:-

Jira database:-

Environment variable | Description |
-------------------- | ----------- |
DATABASE_HOST        | The location of the database - can be a DNS name or IP address
DATABASE_PORT        | The port the database is listening on
DATABASE_USERNAME    | The username to connects to the database with
PGPASSWORD           | The password used when connecting to the database

AWS S3:-

Environment variable    | Description |
----------------------- | ----------- |
BUCKET_NAME             | The S3 bucket to use for the backups
AWS_ACCESS\_KEY\_ID     | The AWS key used to authenticate with the bucket
AWS_SECRET\_ACCESS\_KEY | The secret key used to authenticate with the BUCKET_NAME

Note: if using this in Kube, the environment variables will have to be base64 encoded!

## Usage
The image is designed to work alongside a separate container running Jira in Kubernetes. An example of the deployment in Kube can be found on `UKHomeOffice/dq-kube-jira` repo:-

https://github.com/UKHomeOffice/dq-kube-jira/blob/jira-s3-backup/deployment.yml

The below examples show how to start the container in Docker.

* Pull Docker image from Quay:-

```
docker pull quay.io/ukhomeofficedigital/dq-jira-s3-backup
```

* Before starting the container, make sure the environment variables are set.

* Start the container using Docker run:-

```
docker run -it --rm --name s3-backup quay.io/repository/ukhomeofficedigital/dq-jira-s3-backup
```
