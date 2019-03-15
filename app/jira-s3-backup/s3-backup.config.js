module.exports = {
  apps : [
    {
    	name	: "Jira-bacup-to-s3",
	   	script	: "/scripts/s3-backup.sh",
    	exec_interpreter: "bash",
    	env: {
    	  START_HOUR_1: 06,
    	  START_HOUR_2: 18,
    	  DATABASE_HOST: process.argv[6],
    	  DATABASE_NAME: process.argv[7],
    	  PGPASSWORD: process.argv[8],
    	  DATABASE_PORT: process.argv[9],
    	  DATABASE_USERNAME: process.argv[10],
    	  BUCKET_NAME: process.argv[11],
    	  AWS_ACCESS_KEY_ID: process.argv[12],
    	  AWS_SECRET_ACCESS_KEY: process.argv[13]
    	}
    }
  ]
}
