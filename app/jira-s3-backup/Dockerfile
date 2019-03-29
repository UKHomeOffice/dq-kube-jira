FROM quay.io/ukhomeofficedigital/centos-base:v0.5.12

LABEL maintainer="dqdevops@homeoffice.gsi.gov.uk"

ENV USERMAP_UID 1000

RUN yum update -y \
    && yum upgrade -y \
    && yum install -y epel-release \
    && yum install -y python-pip \
    && curl -sL https://raw.githubusercontent.com/nodesource/distributions/master/rpm/setup_11.x -o setup_11.x && bash setup_11.x && rm setup_11.x \
    && yum install -y nodejs \
    && npm install -g pm2

RUN groupadd -r s3user && \
useradd -u $USERMAP_UID -r -g s3user s3user && \
groupadd docker && \
usermod -aG docker s3user && \
mkdir -p /home/s3user && \
chown -R s3user:s3user /home/s3user/ && \
mkdir /scripts/ && \
mkdir /backup/ && \
chown -R s3user:s3user /backup

# Copy in backup script
ADD scripts /scripts/
RUN chmod +x /scripts/s3-backup.sh

# Copy in s3.config.js
COPY ./s3-backup.config.js /s3-backup.config.js

# Add AWS Cli tool
RUN pip install awscli --upgrade

# Add postgresql-client
RUN yum install -y postgresql

# Change user to s3user
USER ${USERMAP_UID}

CMD pm2-docker start /s3-backup.config.js  -- --config $DATABASE_HOST $DATABASE_NAME $PGPASSWORD $DATABASE_PORT $DATABASE_USERNAME $BUCKET_NAME $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY

RUN pm2 save
