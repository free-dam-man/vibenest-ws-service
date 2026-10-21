FROM alpine:3.20
RUN apk add --no-cache nginx unzip curl ca-certificates \
 && mkdir -p /usr/local/xray \
 && curl -fsSL -o /tmp/x.zip https://github.com/XTLS/Xray-core/releases/download/v26.3.27/Xray-linux-64.zip \
 && unzip -o /tmp/x.zip -d /usr/local/xray \
 && chmod +x /usr/local/xray/xray \
 && rm /tmp/x.zip
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh
CMD ["/entry.sh"]
