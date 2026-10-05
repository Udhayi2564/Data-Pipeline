# SeaTunnel 3.0.0 runtime - custom Dockerfile
# Use official image and add configs

FROM apache/seatunnel:3.0.0

# Set working directory
WORKDIR /opt/seatunnel

# Create directories
RUN mkdir -p /opt/seatunnel/configs/batch \
    && mkdir -p /opt/seatunnel/configs/streaming \
    && mkdir -p /opt/seatunnel/sql \
    && mkdir -p /opt/seatunnel/scripts

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /bin/bash -c 'test -f /opt/seatunnel/configs/batch/orders.conf || exit 1'

# Default command
CMD ["bin/seatunnel-start.sh"]