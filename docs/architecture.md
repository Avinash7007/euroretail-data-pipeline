# Architecture & Design Decisions

## End-to-End Flow

```text
AWS S3
  │
  │ Snowflake Storage Integration
  ▼
RAW
  │  source-aligned STRING values
  │  fail-fast COPY INTO
  ▼
STAGING
  │  TRY_* type conversion
  │  normalization
  │  deterministic keys
  │  data-quality assertions
  ▼
REPORTING
  │  business metrics and aggregates
  ▼
Power BI / SQL consumers
```

The pipeline follows a layered ELT design. Each layer has a single responsibility and downstream consumers do not query the raw landing tables directly.

## RAW Layer

**Purpose:** Preserve the source representation from S3.

- Seven source-aligned tables.
- String-based ingestion prevents source formatting problems from becoming irreversible transformations.
- `COPY INTO` uses `ON_ERROR = 'ABORT_STATEMENT'` so malformed files fail visibly.
- `FORCE = FALSE` prevents already-loaded files from being reloaded during normal reruns.
- Source files remain in S3; Snowflake is not configured to purge them after load.

## STAGING Layer

**Purpose:** Convert source-aligned values into analytics-ready types without modifying RAW.

- `TRY_TO_DATE`, `TRY_TO_NUMBER`, and `TRY_TO_DECIMAL` handle conversion safely.
- Empty strings are normalized to NULL.
- Deterministic SHA-256 keys are generated for core dimensions/facts.
- Data-quality checks cover required identifiers, dates, numeric fields, and key references.

## REPORTING Layer

**Purpose:** Provide stable, narrow interfaces for BI and analytical consumers.

Current reporting views:

- `DAILY_SALES`
- `CUSTOMER_SALES`
- `PRODUCT_PERFORMANCE`
- `RETURNS_SUMMARY`
- `DELIVERY_PERFORMANCE`
- `EXECUTIVE_KPIS`

Views are used for this project because the reporting layer is primarily a semantic/consumption layer. Physical tables or incremental models can be introduced later if workload size or latency requires them.

## AWS + Snowflake Security

Snowflake Storage Integration delegates access to an AWS IAM role instead of storing AWS access keys in SQL. The S3 location is restricted to the `s3://euro-retails/raw/` prefix. citeturn0search0turn0search5

The integration script deliberately uses `CREATE STORAGE INTEGRATION IF NOT EXISTS`. After the integration exists, configuration changes should use `ALTER STORAGE INTEGRATION`; Snowflake warns that `CREATE OR REPLACE STORAGE INTEGRATION` recreates the object and can break stage associations. citeturn1search0turn1search2

## Deployment Safety

Snowflake's `CREATE OR ALTER` syntax is used for objects where supported because it provides a declarative, rerunnable deployment pattern while preserving existing object state where possible. citeturn1search3turn3search0

The pipeline is therefore designed around:

1. **Idempotent infrastructure** — rerunning DDL should not destroy loaded RAW data.
2. **Fail-fast ingestion** — malformed source data is not silently accepted.
3. **Immutable source retention** — S3 remains the recoverable landing source.
4. **Quality gates** — STAGING promotion is checked before reporting consumption.
5. **Separation of concerns** — ingestion, transformation, validation and reporting are separate SQL deployments.

## Cost Management

The warehouse is XSMALL with a 60-second auto-suspend and auto-resume enabled. The project is intentionally sized for development/portfolio workloads; production sizing should be driven by concurrency, query duration and workload volume.

## Operational Runbook

```text
1. Validate AWS IAM trust + S3 permissions.
2. Create / validate S3_INT.
3. Create database, warehouse and schemas.
4. Create CSV format and external stage.
5. Create RAW tables.
6. COPY source files into RAW.
7. Run 06_verify.sql.
8. Build STAGING views.
9. Run data-quality checks; investigate FAIL rows.
10. Build REPORTING views.
11. Connect BI consumers to REPORTING only.
```
