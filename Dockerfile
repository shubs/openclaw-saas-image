# OpenClaw SaaS - Custom Docker image
FROM node:22-slim

RUN apt-get update && apt-get install -y git curl jq && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .
RUN npm ci && npm run build

RUN mkdir -p /home/node/.openclaw/workspace
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown -R node:node /app /home/node

USER node
ENV HOME=/home/node
ENV OPENCLAW_CONFIG_DIR=/home/node/.openclaw
EXPOSE 18789
ENTRYPOINT ["/entrypoint.sh"]
