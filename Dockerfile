FROM node:22-slim

RUN apt-get update && apt-get install -y git curl jq && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .
RUN npm ci && npm run build

RUN mkdir -p /home/node/.openclaw/workspace

# Create entrypoint inline
RUN echo '#!/bin/bash\n\
set -e\n\
CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-/home/node/.openclaw}"\n\
CONFIG_FILE="$CONFIG_DIR/openclaw.json"\n\
mkdir -p "$CONFIG_DIR/workspace"\n\
ALLOW_FROM=""\n\
if [ -n "$OPENCLAW_TELEGRAM_ALLOW_FROM" ]; then\n\
    ALLOW_FROM="\"$OPENCLAW_TELEGRAM_ALLOW_FROM\""\n\
fi\n\
cat > "$CONFIG_FILE" << EOF\n\
{\n\
  "gateway": {\n\
    "port": ${OPENCLAW_GATEWAY_PORT:-18789},\n\
    "mode": "${OPENCLAW_GATEWAY_MODE:-local}",\n\
    "auth": { "mode": "token", "token": "${OPENCLAW_GATEWAY_TOKEN}" }\n\
  },\n\
  "agents": { "defaults": { "workspace": "$CONFIG_DIR/workspace" } },\n\
  "channels": {\n\
    "telegram": {\n\
      "enabled": true,\n\
      "botToken": "${TELEGRAM_BOT_TOKEN}",\n\
      "allowFrom": [$ALLOW_FROM]\n\
    }\n\
  }\n\
}\n\
EOF\n\
echo "🦞 OpenClaw SaaS starting..."\n\
exec node dist/index.js gateway --bind "${OPENCLAW_GATEWAY_BIND:-lan}" --port "${OPENCLAW_GATEWAY_PORT:-18789}"' > /entrypoint.sh && chmod +x /entrypoint.sh

RUN chown -R node:node /app /home/node

USER node
ENV HOME=/home/node
ENV OPENCLAW_CONFIG_DIR=/home/node/.openclaw
EXPOSE 18789
ENTRYPOINT ["/entrypoint.sh"]
