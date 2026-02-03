# OpenClaw SaaS Image

Custom Docker image for OpenClaw SaaS deployment.

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ANTHROPIC_API_KEY` | Anthropic API key | required |
| `TELEGRAM_BOT_TOKEN` | Telegram bot token | required |
| `OPENCLAW_TELEGRAM_ALLOW_FROM` | Telegram user ID allowed | required |
| `OPENCLAW_GATEWAY_TOKEN` | Gateway auth token | required |
| `OPENCLAW_GATEWAY_MODE` | Gateway mode | `local` |
| `OPENCLAW_GATEWAY_PORT` | Gateway port | `18789` |
| `OPENCLAW_GATEWAY_BIND` | Bind address | `lan` |

## Usage

```bash
docker build -t openclaw-saas .
docker run -e ANTHROPIC_API_KEY=... -e TELEGRAM_BOT_TOKEN=... openclaw-saas
```
