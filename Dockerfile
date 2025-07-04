FROM node:18-slim

RUN apt-get update && \
    apt-get install -y python3-pip jq && \
    pip install yq && \
    npm install -g @redocly/cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY generate-public-api.sh /app/generate-public-api.sh
WORKDIR /github/workspace
ENTRYPOINT ["/app/generate-public-api.sh"]