FROM ghcr.io/openclaw/openclaw:latest
COPY security/   /app/security/
COPY config/     /app/config/
COPY extensions/ /app/extensions/
COPY skills/     /app/skills/
COPY docs/       /app/docs/
EXPOSE 18789