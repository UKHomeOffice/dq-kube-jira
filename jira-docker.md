# JIRA Docker

> NB. This is not the version maintained by the ACP team


[![Docker Repository on Quay](https://quay.io/repository/ukhomeofficedigital/jira-docker/status "Docker Repository on Quay")](https://quay.io/repository/ukhomeofficedigital/jira-docker)

## Introduction

This Docker image provides JIRA as a Docker container intended for use in the UK Home Office ACP.


### Database

This JIRA docker image uses a PostgreSQL database for its backend.

NOTE: There is **no** local database running in this JIRA docker image. It expects to use a separate database such as an additional container running in Kube, or an AWS RDS instance for example. Whichever option is preferred can be specified using the `DATABASE_*` environment variables detailed further down this README.


### Reverse Proxy

This JIRA docker image is expected to be deployed behind a reverse proxy such as Nginx. The proxy is responsible for providing SSL termination. Note the `SERVER_REDIRECT_PORT` environment variable listed below.

### Environment variables

The image requires the following environment variables to be set as part of the deployment as they are used to set the server's proxy and database connections at runtime. If the environment variables are not set the container will not start.

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

## Usage examples

Run the container in Docker (make sure to set all env vars with the '-e' flag):-

```
docker run -tid --name jira -e SERVER_PORT=8080 -e SERVER_REDIRECT_PORT 10443 quay.io/ukhomeofficedigital/jira-docker:7.12.0
```

This container is used in the [UKHomeOffice/dq-kube-jira](https://github.com/UKHomeOffice/dq-kube-jira) repo, which using [KD](https://github.com/UKHomeOffice/kd) deploys JIRA alongside some other containers into Kubernetes. See the README and Kubernetes deployment files in the [UKHomeOffice/dq-kube-jira](https://github.com/UKHomeOffice/dq-kube-jira) repo for more information.

## Credits

The following people have contributed to the development of this project:

- [@tomfitzherbert](https://github.com/tomfitzherbert)

## Licensing

This project is released under the MIT license.
