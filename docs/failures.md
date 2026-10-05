# Failure Handling Matrix

| # | Failure | Detection | Retry | Recovery | Duplicates? | Action |
|---|---------|-----------|-------|----------|-------------|--------|
| 1 | Oracle connection failure | JDBC connect timeout | Yes | N/A | No | Check listener, credentials |
| 2 | PostgreSQL connection failure | JDBC connect timeout | Yes | N/A | No | Check pg_isready |
| 3 | Invalid JDBC driver | ClassNotFound | No | Restart | No | Verify driver jar |
| 4 | Invalid HOCON | ParseException | No | Fix config | N/A | Validate config syntax |
| 5 | Source query failure | SQLException | Yes | Check SQL | No | Fix query/schema |
| 6 | Target table missing | No such table | Yes | Auto-create | No | enable generate_sink_sql |
| 7 | Target schema missing | No such schema | Yes | Auto-create | No | schema_save_mode |
| 8 | Datatype mismatch | CastException | No | Fix source | Maybe | Check mapping |
| 9 | Primary key conflict | DuplicateKey | First wins | N/A | Yes | unique_mode |
| 10 | Duplicate CDC event | idempotency key | No | Skip | No | primary_keys config |
| 11 | CDC UPDATE failure | Sink exception | Yes | Retry | Maybe | Sink retry |
| 12 | CDC DELETE failure | Sink exception | Yes | Retry | Maybe | Sink retry |
| 13 | Worker restart | Heartbeat loss | Auto | Checkpoint | Depends | HA config |
| 14 | Job restart | Failure | Auto | Checkpoint | Depends | Restart strategy |
| 15 | Checkpoint recovery | Auto | N/A | Restore state | No | Enabled |
| 16 | LogMiner failure | CDC error | Yes | Re-snapshot | Maybe | Restart connector |
| 17 | Redo/archive unavailable | LogMiner error | Yes | Wait | No | Enable archivelog |
| 18 | SCN unavailable | Timestamp error | Yes | Skip | Maybe | Use latest SCN |
| 19 | Snapshot failure | Source error | Yes | Restart | Maybe | Re-run snapshot |
| 20 | Sink failure | JDBC error | Yes | Retry | Maybe | Check target |

## Oracle 26ai Compatibility
Oracle 26ai compatibility is not officially supported. Verify:
1. JDBC connection
2. SELECT
3. Snapshot
4. LogMiner access
5. CDC INSERT/UPDATE/DELETE
6. Restart/recovery