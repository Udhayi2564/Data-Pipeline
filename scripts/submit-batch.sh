#!/bin/bash
# Submit batch job via SeaTunnel REST API
# Usage: ./submit-batch.sh [config_path]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_PATH="${1:-configs/batch/orders.conf}"
REST_URL="http://localhost:8080"
JOB_NAME="orders-migration-batch"

FullConfigPath="$PROJECT_ROOT/$CONFIG_PATH"

if [ ! -f "$FullConfigPath" ]; then
  echo "Config not found: $FullConfigPath"
  exit 1
fi

echo "Submitting batch job: $JOB_NAME"
echo "Config: $FullConfigPath"

CONFIG_B64=$(base64 -w 0 "$FullConfigPath")

curl -s -X POST "$REST_URL/api/v1/plugin/job/submit" \
  -H "Content-Type: application/json" \
  -d "{\"config\":\"$CONFIG_B64\",\"jobName\":\"$JOB_NAME\"}" | tee /tmp/submit_response.json

echo ""
JOB_ID=$(cat /tmp/submit_response.json | grep -o '"jobId":"[^"]*"' | cut -d'"' -f4)
echo "Job ID: $JOB_ID"