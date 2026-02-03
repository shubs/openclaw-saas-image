#!/bin/bash
set -e

CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-/home/node/.openclaw}"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"

mkdir -p "$CONFIG_DIR/workspace"

# Build allowFrom array
ALLOW_FROM=""
if [ -n "$OPENCLAW_TELEGRAM_ALLOW_FROM" ]; then
    ALLOW_FROM="\"$OPENCLAW_TELEGRAM_ALLOW_FROM\""
fi

# Generate config
cat > "$CONFIG_FILE" << EOF
{
  "gateway": {
    "port": ${OPENCLAW_GATEWAY_PORT:-18789},
    "mode": "${OPENCLAW_GATEWAY_MODE:-local}",
    "auth": {
      "mode": "token",
      "token": "${OPENCLAW_GATEWAY_TOKEN}"
    }
  },
  "agents": {
    "defaults": {
      "workspace": "$CONFIG_DIR/workspace"
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "${TELEGRAM_BOT_TOKEN}",
      "allowFrom": [$ALLOW_FROM]
    }
  }
}
EOF

echo "🦞 OpenClaw SaaS starting..."
echo "Config: $CONFIG_FILE"

exec node dist/index.js gateway --bind "${OPENCLAW_GATEWAY_BIND:-lan}" --port "${OPENCLAW_GATEWAY_PORT:-18789}"
