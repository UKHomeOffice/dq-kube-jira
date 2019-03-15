# DQ Kube JIRA

## Introduction

This repo contains a kubernetes deployment for the DQ teams JIRA install, as well as the files required to create the JIRA docker container (jira-docker) and a backup container (jira-s3-backup) which backs up JIRA to AWS S3.

## Layout

Originally, the JIRA docker container and the backup container were built in separate repos. They have been combined into this repo, so that all of the files necessary to build and deploy DQ's JIRA install are available in one place.

This repo contains the following:

```
dq-kube-jira
├── LICENSE
├── README.md
├── app
│   ├── jira-docker
│   │   ├── Dockerfile
│   │   ├── assets
│   │   │   ├── jira_home
│   │   │   │   └── dbconfig.xml
│   │   │   └── jira_install
│   │   │       └── conf
│   │   │           └── server.xml
│   │   └── docker-entrypoint.sh
│   └── jira-s3-backup
│       ├── Dockerfile
│       ├── s3-backup.config.js
│       ├── s3-backup.sh
│       └── scripts
│           └── s3-backup.sh
├── deployment.yml
├── ingress.yml
├── jira-docker.md
├── jira-kube.md
├── jira-s3-backup.md
├── network-policy.yml
├── pvc.yml
├── secrets.yml
└── service.yml
```

As seen above, the JIRA docker container and backup container are built in their respective `app/` directories.

## Changing the JIRA version to deploy

The version of JIRA that is built and deployed can be easily changed by editing the [.drone.yml](./.drone.yml) file, changing the value of `JIRA_VERSION` inside the `matrix` block at the top of the file.

## Documentation

Each part of the deployment (kube, jira-docker, jira-s3-backup) is documented with separate READMEs. These can be found at the following locations in the root of the repo:

[JIRA docker container README](./jira-docker.md)</br>
[JIRA to s3 backup container README](./jira-s3-backup.md)</br>
[JIRA kube deployment README](./jira-kube.md)
