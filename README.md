# SeaTunnel Oracle -> PostgreSQL Migration Executor

## Architecture
```
TRANSPILER -> SeaTunnel HOCON config
SEATUNNEL -> executes config (no Kafka, Airflow, Python, FastAPI)

Oracle JDBC -> SeaTunnel BATCH -> PostgreSQL JDBC
```

## Quick Start

### 1. Start environment
```powershell
cd runtime
docker compose up -d
```

Wait for all containers to be healthy (Oracle takes ~3-5 minutes):
```powershell
docker ps
```

### 2. Verify services
```powershell
# Check SeaTunnel REST API
curl http://localhost:8080

# Check PostgreSQL
docker exec -it mds-postgres psql -U postgres -d etl_target -c "SELECT 1"
```

### 3. Submit batch job
```powershell
.\scripts\submit-batch.ps1
```

### 4. Check job status
```powershell
# Get all jobs
.\scripts\check-job.ps1

# Check specific job
.\scripts\check-job.ps1 -JobId <job_id>
```

### 5. Validate results
```powershell
.\scripts\validate.ps1
```

### 6. Stop job (if needed)
```powershell
.\scripts\stop-job.ps1 -JobId <job_id>
```

## Migration Scenario

**From Oracle:** Table `HR.SEATUNNEL_ORDERS` with data:
```
ORDER_ID | CUSTOMER_NAME | PRODUCT_NAME | CATEGORY | QUANTITY | UNIT_PRICE | ORDER_STATUS | UPDATED_AT
1        | Alice Smith   | Widget A     | Hardware | 10       | 9.99       | SHIPPED      | ...
2        | Bob Jones     | Widget B     | Hardware | 5        | 14.50      | PENDING      | ...
3        | Carol Lee     | Gadget X     | Software | 2        | 199.00     | SHIPPED      | ...
4        | Dave Park     | Gadget Y     | Software | 1        | 249.00     | CANCELLED    | ...
5        | Eve Brown     | Thing Z      | Accessories | 3     | 49.99      | PENDING      | ...
```

**To PostgreSQL:** Schema `serving`, Table `orders` (auto-created by SeaTunnel)

**What happens during migration:**
1. SeaTunnel reads from Oracle `HR.SEATUNNEL_ORDERS` via JDBC
2. Columns are mapped: `ORDER_ID → order_id`, `CUSTOMER_NAME → customer_name`, etc.
3. SeaTunnel auto-creates PostgreSQL schema `serving` and table `orders`
4. Data is batch-inserted with `INSERT` statements
5. Primary key `ORDER_ID` ensures no duplicates

**Expected result:**
- 5 rows in `serving.orders` in PostgreSQL

## Environment Variables
- ORACLE_USER=hr, ORACLE_PASSWORD=HrOracle123
- POSTGRES_USER=postgres, POSTGRES_PASSWORD=Postgres123