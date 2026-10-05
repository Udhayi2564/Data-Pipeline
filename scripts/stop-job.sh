#!/bin/bash
# Stop job
# Usage: ./stop-job.sh job_id

REST_URL="http://localhost:8080"
JOB_ID="${1}"

if [ -z "$JOB_ID" ]; then
  echo "Usage: ./stop-job.sh <job_id>"
  exit 1
fi

curl -s -X POST "$REST_URL/api/v1/plugin/job/stop/$JOB_ID"