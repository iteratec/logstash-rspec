FROM openjdk:8
LABEL maintainer="nils.kuhn@iteratec.com"

USER root:root

ARG LOGSTASH_VERSION=7.3.0
ARG PATH_LOGSTASH_HOME=/opt/logstash
WORKDIR /opt/logstash

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -yq install git rake && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/elastic/logstash.git $PATH_LOGSTASH_HOME && \
    git checkout v$LOGSTASH_VERSION && \
    ./gradlew bootstrap && \
    ./bin/logstash-plugin install --development && \
    rake test:install-default

VOLUME ["$PATH_LOGSTASH_HOME/filters-under-test", "$PATH_LOGSTASH_HOME/rspec-tests"]

CMD [ "/opt/logstash/rspec-tests/**/*_spec.rb" ]
ENTRYPOINT ["/opt/logstash/bin/rspec", "-P"]