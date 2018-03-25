# Deploying JIRA in Docker on ACP

## Deployment

This project is expected to be used to deploy in the UK Home Office ACP and
therefore depends on certain features present in the platform.

### Additional manual steps

To get JIRA to work correctly with the proxy, the `server.xml` file needs to be
overwritten with the version in this repository. To do this deploy the container
and use `kubectl cp` to transfer the file on to the running container.

```
kubectl cp jira-conf/server.xml <jira pod id>:/opt/atlassian/jira/conf/server.xml -c jira
```
