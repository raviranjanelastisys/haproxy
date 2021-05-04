FROM asia.gcr.io/ct-prod-infra/haproxybase:23_08_19

LABEL maintainer="ravi.ranjan@cleartrip.com>"

RUN set -exo pipefail \
    && apk add --no-cache \
        rsyslog tzdata\
    && apk del syslog-ng \
    && mkdir -p /etc/rsyslog.d \
    && touch /var/log/haproxy.log \
    && ln -sf /dev/stdout /var/log/haproxy.log \
    && cp /usr/share/zoneinfo/Asia/Calcutta /etc/localtime \
    && echo "Asia/Calcutta" >  /etc/timezone \
    && apk del tzdata

COPY docker-entrypoint.sh /
COPY rsyslog.conf /etc/rsyslog.d/
RUN mkdir -p /usr/local/etc/haproxy/
COPY 200pingdom.http /usr/local/etc/haproxy/200pingdom.http
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["-f", "/usr/local/etc/haproxy/haproxy.cfg"]
