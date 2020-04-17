FROM python:3.5-slim

LABEL maintainer="dqdevops@digital.homeoffice.gov.uk"

ENV AWS_REGION eu-west-2
ENV USERMAP_UID 1000

COPY awslogs.conf ./

RUN apt-get update && apt-get install -y \
    curl \
    vim \
    cron \
    && useradd -u $USERMAP_UID -m cwagent \
    && curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O \
    && chmod +x ./awslogs-agent-setup.py \
    && python ./awslogs-agent-setup.py --non-interactive --region ${AWS_REGION} --configfile ./awslogs.conf

COPY aws.conf /var/awslogs/etc

RUN chown -R cwagent /var/awslogs \
    && chown cwagent /var/log/awslogs.log \
    && rm -rf /var/lib/apt/lists/*

COPY "docker-entrypoint.sh" "/"
RUN chmod +x /docker-entrypoint.sh

USER ${USERMAP_UID}

CMD ["/bin/sh", "/var/awslogs/bin/awslogs-agent-launcher.sh"]
