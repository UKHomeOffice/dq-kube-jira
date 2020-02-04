#!/bin/bash

set -e

send_msg_to_slack() {
	post='
	{
			"text": ":fire: :sad_parrot: An error has occurred in Jira backup script :sad_parrot: :fire:",
			"attachments": [
				{
						"text": "'"${1}"'",
						"color": "#B22222",
						"attachment_type": "default",
						"fields": [
								{
										"title": "Priority",
										"value": "High",
										"short": "false"
								}
						],
						"footer": "Kubernetes API",
						"footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png"
				}
		]
	}'

	echo $post | curl -X POST $SLACK_WEBHOOK -H 'Content-type: application/json' --data @-
	echo "slack message sent"
}

log_error() {
	echo "Error! ${1}"
	send_msg_to_slack "${1}"
	exit 1
}

backup_data_dir() {
	# Create a backup of the attachment and avatar directories in JIRA_HOME/data
	echo "Backing up data directory"
	mkdir -p /backup/jira/${BACKUP_DAY}/ || log_error "Failed to create backup data directory"
	if ! tar -czf /backup/jira/${BACKUP_DAY}/${BACKUP_TIME}-jira.tar.gz /var/atlassian/jira/data 2> "$ERROR_LOG"; then
		log_error "$(cat "${ERROR_LOG}" | tr -d '"')"
	fi

}

backup_database() {
	# Create a dump of the database
	echo "Backing up database"
	mkdir -p /backup/jira-db/$BACKUP_DAY/$BACKUP_TIME/ || log_error "Failed to create backup directory"
	if ! pg_dump -h $DATABASE_HOST -U $DATABASE_USERNAME $DATABASE_NAME > /backup/jira-db/$BACKUP_DAY/$BACKUP_TIME/jira-db.sql 2> "$ERROR_LOG"; then
		log_error "$(cat "${ERROR_LOG}" | tr -d '"')"
	fi
}

clean_up() {
	# Cleanup export directory (keep 2 days worth of backups on disk)
	echo "Cleaning up old backups"
	[ -d "/var/atlassian/jira/export/" ] && find "/var/atlassian/jira/export/" -type f -iname "*.zip" -mtime +2 -exec rm {} \; || log_error "no directory exists"
	[ -d "/backup/jira/" ] && find "/backup/jira/" -type d -mtime +2 -exec rm -rf {} \; || log_error "no directory exists"
	[ -d "/backup/jira-db/" ] && find "/backup/jira-db/" -type d -mtime +2 -exec rm -rf {} \; || log_error "no directory exists"
}

copy_to_s3() {
	# Copy to S3 bucket
	echo "Copying data directory to S3"
	if ! /usr/bin/aws s3 cp --recursive --quiet /backup/jira/ s3://$BUCKET_NAME/jira-backup/data/ 2> "$ERROR_LOG"; then
		log_error "$(cat "${ERROR_LOG}" | tr -d '"')"
	fi
	echo "Copying database backup to S3"
	if ! /usr/bin/aws s3 cp --recursive --quiet /backup/jira-db/ s3://$BUCKET_NAME/jira-backup/jira-db/ 2> "$ERROR_LOG"; then
		log_error "$(cat "${ERROR_LOG}" | tr -d '"')"
	fi
	echo "Copying export directory to S3"
	if ! /usr/bin/aws s3 cp --recursive --quiet /var/atlassian/jira/export/ s3://$BUCKET_NAME/jira-backup/export/ 2> "$ERROR_LOG"; then
		log_error "$(cat "${ERROR_LOG}" | tr -d '"')"
	fi
}

main() {
	# Set current time
	export CURRENT=$(date +%k)
	if [ $CURRENT = $START_HOUR_1 -o $CURRENT = $START_HOUR_2 ]; then
		# Set variables for date and time - used for folder structure
		export BACKUP_DAY=$(date +%Y-%b-%d)
		export BACKUP_TIME=$(date +%Y-%b-%d-%H%M)
		echo "Backups starting..."
		backup_data_dir
		backup_database
		clean_up
		copy_to_s3
		echo "Backups finished"
		# sleep 3600
		sleep 300
	else
		echo "Not time yet..."
		# Sleep for an hour
		# sleep 3600
		sleep 300
	fi
}

ERROR_LOG=$(mktemp)
trap 'rm -f "$ERROR_LOG"' EXIT
main
