FROM quay.io/ukhomeofficedigital/centos-base:v0.5.15

LABEL maintainer="dqdevops@digital.homeoffice.gov.uk"

ENV USERMAP_UID 1000

RUN useradd -u $USERMAP_UID -r logger

USER ${USERMAP_UID}

CMD tail -n+1 -f $ACCESS_LOG_PATH
