# OpenClaw SaaS - Custom Docker image with config generation from env vars
FROM node:22-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Clone OpenClaw
WORKDIR /app
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .

# Install dependencies and build
RUN npm ci && npm run build

# Create directories
RUN mkdir -p /home/node/.openclaw/workspace

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set ownership
RUN chown -R node:node /app /home/node

USER node
WORKDIR /app

ENV HOME=/home/node
ENV OPENCLAW_CONFIG_DIR=/home/node/.openclaw

EXPOSE 18789

ENTRYPOINT ["/entrypoint.sh"]
