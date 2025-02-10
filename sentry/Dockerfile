FROM alpine:latest
WORKDIR /app

ARG NETWORK
RUN echo "Build arg NETWORK=$NETWORK"

# Set environment variables.
ARG UPSTREAM_VERSION

# Install deps - supervisor is in community repo
RUN apk add --no-cache supervisor wget bash && \
    mkdir -p /var/log/supervisor /var/run

# Download and install contributoor
RUN wget "https://github.com/ethpandaops/contributoor/releases/download/v${UPSTREAM_VERSION}/contributoor_${UPSTREAM_VERSION}_linux_amd64.tar.gz" -O contributoor.tar.gz && \
    tar -xzf contributoor.tar.gz && \
    mv sentry /usr/local/bin/contributoor && \
    chmod +x /usr/local/bin/contributoor && \
    rm contributoor.tar.gz

# Copy supervisord config and start script.
COPY supervisord.conf /etc/supervisord/supervisord.conf
COPY contributoor-start.sh /usr/local/bin/contributoor-start.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set permissions.
RUN chmod +x /usr/local/bin/contributoor-start.sh /usr/local/bin/entrypoint.sh

ENV NETWORK=${NETWORK}

# Boot it!
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]  
  