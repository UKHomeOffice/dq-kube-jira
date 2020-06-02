FROM busybox:1.31.1

LABEL maintainer="dqdevops@digital.homeoffice.gov.uk"

ENV USERMAP_UID 1000

RUN useradd -u $USERMAP_UID

CMD tail -n+1 -f $ACCESS_LOG_PATH
