#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:?UUID environment variable is required}"
WS_PATH="${WS_PATH:-/vn-9x7}"
cat > /tmp/c.json <<JSON
{"log":{"loglevel":"warning"},"inbounds":[{"listen":"127.0.0.1","port":10001,"protocol":"vless","settings":{"clients":[{"id":"$UUID"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"$WS_PATH"}}}],"outbounds":[{"protocol":"freedom"}]}
JSON
cat > /tmp/nginx.conf <<NGINX
pid /tmp/nginx.pid;
worker_processes 1;
error_log /dev/stderr;
events { worker_connections 256; }
http {
  access_log /dev/stdout;
  server {
    listen $PORT;
    location = / { return 200 "ok\n"; }
    location = /healthz { return 200 "ok\n"; }
    location $WS_PATH {
      proxy_pass http://127.0.0.1:10001;
      proxy_http_version 1.1;
      proxy_set_header Upgrade \$http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_set_header Host \$host;
      proxy_read_timeout 3600s;
      proxy_send_timeout 3600s;
    }
  }
}
NGINX
/usr/local/xray/xray run -c /tmp/c.json &
exec nginx -c /tmp/nginx.conf -g 'daemon off;'
