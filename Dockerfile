FROM node:18-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg ca-certificates && \
    curl -Lo /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod +x /usr/bin/yq && \
    npm install -g @redocly/cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY generate-public-api.sh /app/generate-public-api.sh
RUN chmod +x /app/generate-public-api.sh

WORKDIR /github/workspace

ENTRYPOINT ["/app/generate-public-api.sh"]