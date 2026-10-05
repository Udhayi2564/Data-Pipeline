#!/bin/bash
# Validate migration results
# Usage: ./validate.sh [batch|cdc]

MODE="${1:-batch}"

echo "=== Migration Validation ==="
echo "Mode: $MODE"
echo ""

# Check Docker containers
echo "1. Container Status:"
docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null || echo "Docker not available"

echo ""
echo "2. Oracle Data Check:"
echo "   -- Query: SELECT COUNT(*) FROM HR.SEATUNNEL_ORDERS IN oracle"

echo ""
echo "3. PostgreSQL Data Check:"
echo "   -- Query: SELECT COUNT(*) FROM serving.orders IN postgres"

echo ""
echo "4. Comparison:"
echo "   -- Source (Oracle): Should match target (PostgreSQL)"

echo ""
echo "Validation complete. Use direct DB tools for detailed queries:"
echo "  sqlplus hr/HrOracle123@//host.docker.internal:1521/FREEPDB1"
echo "  psql -h localhost -p 5433 -U postgres -d etl_target"