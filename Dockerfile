FROM ghcr.io/openclaw/openclaw:latest

# All config, credentials, and workspace data are persisted
# under /home/node/.openclaw/ via Zeabur's persistent volume.
# No additional build steps needed — the official image is complete.

# The gateway listens on port 18789
EXPOSE 18789
