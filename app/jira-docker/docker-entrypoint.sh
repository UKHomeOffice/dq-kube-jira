#!/usr/bin/env sh

cp /home/jira/templates/dbconfig.xml ${JIRA_HOME}/dbconfig.xml
cp /home/jira/templates/server.xml ${JIRA_INSTALL}/conf/server.xml

# update the server.xml connection settings from environment variables

# Check environment variables have been set before proceeding and remove whitespace.

if  [ -z "${SERVER_PORT// }" ]; then
	echo "SERVER_PORT is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{SERVER_PORT}}/'"${SERVER_PORT}"'/' -i ${JIRA_INSTALL}/conf/server.xml
fi

if [ -z "${SERVER_REDIRECT_PORT// }" ]; then
	echo "SERVER_REDIRECT_PORT is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{SERVER_REDIRECT_PORT}}/'"${SERVER_REDIRECT_PORT}"'/' -i ${JIRA_INSTALL}/conf/server.xml
fi

if [ -z "${SERVER_PROXY_NAME// }" ]; then
	echo "SERVER_PROXY_NAME is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{SERVER_PROXY_NAME}}/'"${SERVER_PROXY_NAME}"'/' -i ${JIRA_INSTALL}/conf/server.xml
fi

if [ -z "${SERVER_PROXY_PORT// }" ]; then
	echo "SERVER_PROXY_PORT is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{SERVER_PROXY_PORT}}/'"${SERVER_PROXY_PORT}"'/' -i ${JIRA_INSTALL}/conf/server.xml
fi

# update the dbconfig.xml settings from environment variables

# Check environment variables have been set before proceeding and remove whitespace.

if [ -z "${DATABASE_HOST// }" ]; then
	echo "DATABASE_HOST is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{DATABASE_HOST}}/'"${DATABASE_HOST}"'/' -i ${JIRA_HOME}/dbconfig.xml
fi

if [ -z "${DATABASE_PORT// }" ]; then
	echo "DATABASE_PORT is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{DATABASE_PORT}}/'"${DATABASE_PORT}"'/' -i ${JIRA_HOME}/dbconfig.xml
fi

if [ -z "${DATABASE_NAME// }" ]; then
	echo "DATABASE_NAME is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{DATABASE_NAME}}/'"${DATABASE_NAME}"'/' -i ${JIRA_HOME}/dbconfig.xml
fi

if [ -z "${DATABASE_USERNAME// }" ]; then
	echo "DATABASE_USERNAME is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{DATABASE_USERNAME}}/'"${DATABASE_USERNAME}"'/' -i ${JIRA_HOME}/dbconfig.xml
fi

if [ -z "${DATABASE_PASSWORD// }" ]; then
	echo "DATABASE_PASSWORD is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{DATABASE_PASSWORD}}/'"${DATABASE_PASSWORD}"'/' -i ${JIRA_HOME}/dbconfig.xml
fi

if [ -z "${DATABASE_SCHEMA_NAME// }" ]; then
	echo "DATABASE_SCHEMA_NAME is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{DATABASE_SCHEMA_NAME}}/'"${DATABASE_SCHEMA_NAME}"'/' -i ${JIRA_HOME}/dbconfig.xml
fi

exec "$@"
