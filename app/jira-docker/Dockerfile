FROM openjdk:8-alpine

LABEL maintainer="dqdevops@homeoffice.gsi.gov.uk"

ARG JIRA_VERSION=${JIRA_VERSION}

ENV JIRA_HOME     /var/atlassian/jira
ENV JIRA_INSTALL  /opt/atlassian/jira
ENV USERMAP_UID 1000

RUN apk update && apk upgrade

RUN set -x \
    && apk del openjdk8 \
    && apk update --quiet \
    && apk upgrade --quiet \
    && apk add --no-cache --quiet openjdk8 xmlstarlet apk-tools curl bash \
    && adduser --disabled-password --gecos "" --uid ${USERMAP_UID} jira \
    && chown jira:jira -R /var \
    && chown jira:jira -R /opt

# Add aws-cli tools
RUN apk add py-pip \
    && pip install --upgrade pip \
    && pip install awscli

# Install Atlassian JIRA and helper tools
RUN mkdir -p ${JIRA_INSTALL}
RUN wget -q -O - https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}.tar.gz | tar xz --strip=1 -C ${JIRA_INSTALL} || \
    wget -q -O - http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-${JIRA_VERSION}.tar.gz | tar xz --strip=1 -C ${JIRA_INSTALL}

RUN mkdir -p                   "/home/jira/templates" \
    && mkdir -p                "${JIRA_HOME}" \
    && mkdir -p                "${JIRA_HOME}/caches/indexes" \
    && chmod -R 700            "${JIRA_HOME}" \
    && chown -R jira:jira      "${JIRA_HOME}" \
    && mkdir -p                "${JIRA_INSTALL}/conf/Catalina" \
    && rm -f                   "${JIRA_INSTALL}/lib/postgresql-9.1-903.jdbc4-atlassian-hosted.jar" \
    && curl -Ls                "https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar" -o "${JIRA_INSTALL}/lib/postgresql-9.4.1212.jar" \
    && chmod -R 700            "${JIRA_INSTALL}/conf" \
    && chmod -R 700            "${JIRA_INSTALL}/logs" \
    && chmod -R 700            "${JIRA_INSTALL}/temp" \
    && chmod -R 700            "${JIRA_INSTALL}/work" \
    && chown -R jira:jira      "${JIRA_INSTALL}/conf" \
    && chown -R jira:jira      "${JIRA_INSTALL}/logs" \
    && chown -R jira:jira      "${JIRA_INSTALL}/temp" \
    && chown -R jira:jira      "${JIRA_INSTALL}/work" \
    && sed --in-place          "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
    && echo -e                 "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties" \
    && touch -d "@0"           "${JIRA_INSTALL}/conf/server.xml" \
    && cp -r "${JIRA_INSTALL}/conf" "${JIRA_INSTALL}/original_conf" \
    && chmod -R 700            "${JIRA_INSTALL}/original_conf" \
    && chown -R jira:jira      "${JIRA_INSTALL}/original_conf"

# add a runtime arg to extend the timeout for plugin installs
RUN sed -i 's/^JVM_SUPPORT_RECOMMENDED_ARGS=""/JVM_SUPPORT_RECOMMENDED_ARGS="-Datlassian.plugins.enable.wait=300"/' ${JIRA_INSTALL}/bin/setenv.sh

VOLUME ["/var/atlassian/jira"]

EXPOSE 8080

WORKDIR /var/atlassian/jira
COPY --chown=jira:jira "assets/jira_home/dbconfig.xml" "/home/jira/templates/"
COPY --chown=jira:jira "assets/jira_install/conf/server.xml" "/home/jira/templates/"

# Turn on http access log
RUN sed -i 's/AccessLogFilter = OFF/AccessLogFilter = ALL/' ${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/log4j.properties

COPY "docker-entrypoint.sh" "/"
RUN chmod +x /docker-entrypoint.sh

USER ${USERMAP_UID}

ENTRYPOINT ["/docker-entrypoint.sh"]

# Run JIRA as a foreground process
CMD ["/opt/atlassian/jira/bin/catalina.sh", "run"]
