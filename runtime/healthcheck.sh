#!/bin/bash
# Health check for SeaTunnel
# Returns 0 if healthy, non-zero otherwise

CONFIG_DIR="/opt/seatunnel/configs"
if [ -z "$CONFIG_DIR" ]; then
  CONFIG_DIR="/opt/seatunnel/configs"
fi

# Check if config directory exists
if [ ! -d "$CONFIG_DIR" ]; then
  echo "Config directory not found: $CONFIG_DIR"
  exit 1
fi

# Check for batch config
if [ ! -f "$CONFIG_DIR/batch/orders.conf" ]; then
  echo "Batch config not found"
  exit 1
fi

# Check Oracle connectivity (if sqlplus available)
# if command -v sqlplus &> /dev/null; then
#   sqlplus hr/HrOracle123@//host.docker.internal:1521/FREEPDB1 @/tmp/test.sql
# fi

echo "Health check passed"
exit 0