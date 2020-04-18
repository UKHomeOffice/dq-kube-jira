#!/bin/bash

if  [ -z "${CW_ACCESS_KEY_ID// }" ]; then
	echo "CW_ACCESS_KEY_ID is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{CW_ACCESS_KEY_ID}}/'"${CW_ACCESS_KEY_ID}"'/' -i /var/awslogs/etc/aws.conf
fi

if [ -z "${CW_SECRET_ACCESS_KEY// }" ]; then
	echo "CW_SECRET_ACCESS_KEY is not defined!!! See README.md for more info."
	exit 1
else
	sed 's/{{CW_SECRET_ACCESS_KEY}}/'"${CW_SECRET_ACCESS_KEY}"'/' -i /var/awslogs/etc/aws.conf
fi

exec "$@"
