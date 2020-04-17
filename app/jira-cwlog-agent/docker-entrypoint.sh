#!/bin/bash

if  [ -z "${CW_ACCESS_KEY// }" ]; then
	echo "SERVER_PORT is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{CW_ACCESS_KEY}}/'"${CW_ACCESS_KEY}"'/' -i /var/awslogs/etc/aws.conf
fi

if [ -z "${CW_SECRET_ACCESS_KEY// }" ]; then
	echo "CW_SECRET_ACCESS_KEY is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{CW_SECRET_ACCESS_KEY}}/'"${CW_SECRET_ACCESS_KEY}"'/' -i /var/awslogs/etc/aws.conf
fi

exec "$@"
