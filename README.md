# vibenest-ws-service

A tiny WebSocket service used for a deployment test on VibeNest.
The container serves a health response on `/` and `/healthz`, and a
WebSocket endpoint on the path given by `WS_PATH` (default `/vn-9x7`).

Required environment variable: `UUID` (a standard UUID string).
Listens on `$PORT` (default 8080).
