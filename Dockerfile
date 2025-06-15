FROM alpine:3.22 AS build


RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash samba shadow tini tzdata && \
    addgroup -S smb && \
    adduser -S -D -H -h /tmp -s /sbin/nologin -G smb -g 'Samba User' smbuser

COPY smb.conf.template /etc/samba/smb.conf.template
COPY start.sh /usr/bin/


FROM scratch
COPY --from=build / /

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/start.sh"]
