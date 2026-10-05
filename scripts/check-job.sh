#!/bin/bash
# Check job status
# Usage: ./check-job.sh [job_id]

REST_URL="http://localhost:8080"
JOB_ID="${1}"

if [ -z "$JOB_ID" ]; then
  curl -s "$REST_URL/api/v1/plugin/job/list" | python3 -m json.tool 2>/dev/null || curl -s "$REST_URL/api/v1/plugin/job/list"
else
  curl -s "$REST_URL/api/v1/plugin/job/status/$JOB_ID" | python3 -m json.tool 2>/dev/null || curl -s "$REST_URL/api/v1/plugin/job/status/$JOB_ID"
fi