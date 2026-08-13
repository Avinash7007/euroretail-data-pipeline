# EuroRetail Data Pipeline

![Status](https://img.shields.io/badge/Status-Production%20Style-brightgreen)
![AWS](https://img.shields.io/badge/AWS-S3-orange)
![Snowflake](https://img.shields.io/badge/Snowflake-ELT-blue)
![SQL](https://img.shields.io/badge/SQL-T--SQL-lightgrey)

An end-to-end retail ELT pipeline that ingests CSV data from **Amazon S3**, loads it into **Snowflake RAW**, applies typed transformations and data-quality checks in **STAGING**, and exposes curated business views in **REPORTING** for BI consumption.

> Portfolio project focused on cloud data engineering patterns: secure ingestion, layered warehouse design, idempotent deployments, data quality, and BI-ready modeling.

## Architecture

```text
Amazon S3
   │
   │ External Stage + Storage Integration
   ▼
Snowflake RAW
(source-aligned, STRING, auditable)
   │
   │ TRY_* casting + normalization + quality checks
   ▼
Snowflake STAGING
(typed, validated, deterministic keys)
   │
   │ business metrics / aggregations
   ▼
Snowflake REPORTING
(BI-ready views)
   │
   ▼
Power BI / SQL consumers
```

Snowflake Storage Integration is used instead of hard-coded AWS access keys. Snowflake recommends storage integrations for secure S3 access because credentials do not need to be embedded in stage or load statements. citeturn0search0turn0search5

## Project Structure

```text
euroretail-data-pipeline/
│
├── sql/
│   ├── 01_raw/
│   │   ├── 01_storage_integration.sql   # S3 trust configuration
│   │   ├── 02_database_setup.sql         # DB, warehouse, schemas
│   │   ├── 03_file_format_stage.sql      # CSV format + S3 stage
│   │   ├── 04_raw_tables.sql             # 7 source-aligned tables
│   │   ├── 05_load_data.sql               # S3 -> RAW COPY INTO
│   │   └── 06_verify.sql                  # load and null checks
│   │
│   ├── 02_staging/
│   │   ├── 01_staging_views.sql           # type casting + normalization
│   │   └── 02_data_quality_checks.sql     # quality assertions
│   │
│   └── 03_reporting/
│       └── 01_reporting_views.sql         # BI-ready business views
│
├── docs/
│   └── architecture.md
│
├── Notebook/
│   └── 01-connt s3.ipynb                  # S3 connectivity exploration
│
├── .gitignore
├── requirements.txt
└── README.md
```

## Data Model

The source contains seven retail entities:

| Table | Layer | Type | Purpose |
|---|---|---|---|
| `DIM_CUSTOMER` | RAW/STAGING | Dimension | Customer, segment and geography |
| `DIM_DATE` | RAW/STAGING | Dimension | Calendar attributes |
| `DIM_PRODUCT` | RAW/STAGING | Dimension | Product hierarchy |
| `DIM_STORE` | RAW/STAGING | Dimension | Store geography |
| `FACT_SALES` | RAW/STAGING | Fact | Orders, quantity, pricing and cost |
| `FACT_RETURNS` | RAW/STAGING | Fact | Returns and refunds |
| `FACT_SHIPMENTS` | RAW/STAGING | Fact | Shipment cost and delivery status |

The reporting layer provides `DAILY_SALES`, `CUSTOMER_SALES`, `PRODUCT_PERFORMANCE`, `RETURNS_SUMMARY`, `DELIVERY_PERFORMANCE`, and `EXECUTIVE_KPIS` views.

## Engineering Practices

### 1. Secure S3 access

The pipeline uses a Snowflake **Storage Integration + AWS IAM role** rather than embedding AWS access keys. The allowed S3 path is restricted to the project landing prefix. citeturn0search0turn1search0

### 2. Non-destructive infrastructure deployment

The deployment scripts avoid unnecessary `CREATE OR REPLACE STORAGE INTEGRATION`. Snowflake documents that replacing a storage integration changes its hidden identity and can break stage associations. `CREATE OR ALTER` is used where supported to make warehouse objects and stages safer to redeploy. citeturn1search0turn1search2turn2search1

### 3. RAW is source-aligned

RAW keeps source fields as strings so the original values remain available for troubleshooting. Type conversion happens in STAGING with `TRY_TO_*` functions.

### 4. Fail-fast ingestion

Production loading uses `ON_ERROR = 'ABORT_STATEMENT'` rather than silently continuing after bad records. This makes ingestion failures visible and prevents an apparently successful pipeline run from hiding malformed data.

### 5. Data quality gates

The STAGING quality script checks critical identifiers, dates, numeric fields, and foreign-key-like references. A healthy run should return `PASS` for every check.

### 6. BI-ready reporting

Reporting views centralize reusable business metrics such as net revenue, gross margin, customer sales, returns, shipment cost, and executive KPIs. Presentation remains outside the warehouse.

## Deployment Order

Run the SQL files in this order:

```text
01_raw/01_storage_integration.sql
01_raw/02_database_setup.sql
01_raw/03_file_format_stage.sql
01_raw/04_raw_tables.sql
01_raw/05_load_data.sql
01_raw/06_verify.sql
02_staging/01_staging_views.sql
02_staging/02_data_quality_checks.sql
03_reporting/01_reporting_views.sql
```

### AWS prerequisite

Create an IAM role that trusts the Snowflake-generated identity and grants the minimum required S3 read permissions for the `s3://euro-retails/raw/` prefix. Snowflake documents `s3:GetBucketLocation`, `s3:GetObject`, `s3:GetObjectVersion`, and `s3:ListBucket` as the core read permissions. citeturn0search0turn0search4

### Snowflake prerequisite

Before running `01_storage_integration.sql`, replace only the placeholders:

```text
<AWS_ACCOUNT_ID>
<IAM_ROLE_NAME>
```

Never commit AWS access keys, secrets, tokens, private keys, `.env` files, or real account-specific credentials.

## Cost Controls

The project uses an XSMALL warehouse with auto-resume and 60-second auto-suspend. The goal is to keep the development pipeline inexpensive while avoiding unnecessary idle compute.

## Validation Checklist

- [x] Secure S3 storage integration pattern
- [x] Restricted S3 landing location
- [x] RAW / STAGING / REPORTING architecture
- [x] Seven RAW source tables
- [x] Idempotent stage and table deployment patterns
- [x] Fail-fast COPY behavior
- [x] Load-history verification
- [x] Staging type conversion
- [x] Data quality assertions
- [x] BI-ready reporting views

## Tech Stack

- **AWS S3** — object storage / landing zone
- **AWS IAM** — role-based access
- **Snowflake** — cloud data warehouse and ELT
- **SQL** — DDL, ingestion, transformation, validation and reporting
- **Power BI** — optional downstream BI consumer
- **Jupyter / Python** — connectivity and exploration notebook

## Author

**Avinash Dubey — Data Analyst | Cloud Data Engineering**

- 📧 Email: [dubeyavinash157@gmail.com](mailto:dubeyavinash157@gmail.com)
- 💼 LinkedIn: [linkedin.com/in/avinash7007](https://www.linkedin.com/in/avinash7007/)
- 🌐 Portfolio: [avinash7007.github.io/avinash-portfolio](https://avinash7007.github.io/avinash-portfolio/)
- 💻 GitHub: [github.com/Avinash7007](https://github.com/Avinash7007)

