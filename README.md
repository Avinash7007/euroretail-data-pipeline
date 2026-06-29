# 🏗️ EuroRetail Data Pipeline — AWS S3 + Snowflake + Power BI

![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![Stack](https://img.shields.io/badge/Stack-Snowflake%20%7C%20AWS%20S3%20%7C%20Power%20BI-blue)
![RAW](https://img.shields.io/badge/RAW-Complete%20✅-brightgreen)
![STAGING](https://img.shields.io/badge/STAGING-In%20Progress%20🔜-yellow)
![REPORTING](https://img.shields.io/badge/REPORTING-Planned%20🔜-lightgrey)

---

## 📌 About This Project

A **hands-on, end-to-end data pipeline** built as part of my upskilling journey from Data Analyst → Cloud Data Engineer.

Instead of following tutorials, I designed and built a production-style pipeline from scratch using real-world retail data — covering ingestion, transformation, and reporting layers.

**Author:** Avinash Dubey — Data Analyst (3 YOE), upskilling in Cloud Data Engineering  
**Connect:** [LinkedIn](https://www.linkedin.com/in/avinash7007/)
<br>
**email** dubeyavinash157@gmail.com

---

## 🎯 Architecture

```
AWS S3 (raw CSVs)
      │
      ▼
❄️ Snowflake — RAW Schema        ← All columns STRING, no transformation
      │
      ▼
❄️ Snowflake — STAGING Schema    ← Type casting, NULL handling, surrogate keys
      │
      ▼
❄️ Snowflake — REPORTING Schema  ← Aggregated views for BI consumption
      │
      ▼
📊 Power BI Dashboard
```

---

## 📂 Folder Structure

```
euroretail-data-pipeline/
│
├── sql/
│   ├── 01_raw/
│   │   ├── 01_storage_integration.sql   ← AWS + Snowflake S3 connection
│   │   ├── 02_database_setup.sql        ← DB, warehouse, schemas
│   │   ├── 03_file_format_stage.sql     ← CSV format + external stage
│   │   ├── 04_raw_tables.sql            ← All 7 raw tables (STRING columns)
│   │   ├── 05_load_data.sql             ← COPY INTO from S3
│   │   └── 06_verify.sql               ← Row counts + load history check
│   │
│   ├── 02_staging/                      ← Coming soon
│   └── 03_reporting/                    ← Coming soon
│
├── docs/
│   └── architecture.md                  ← Design decisions explained
│
└── README.md
```

---

## 📊 Dataset — 7 Tables (Star Schema)

| Table | Type | Description |
|---|---|---|
| `dim_customer` | Dimension | Customer name, segment, region, country |
| `dim_date` | Dimension | Year, month, quarter |
| `dim_product` | Dimension | Product name, category, sub-category |
| `dim_store` | Dimension | Store name, city, region, country |
| `fact_sales` | Fact | Orders, quantity, price, discount, cost |
| `fact_returns` | Fact | Return ID, qty, refund amount |
| `fact_shipments` | Fact | Ship date, cost, delivery status |

---

## ✅ Layer 1 — RAW (Complete)

### Key Design Decisions

| Decision | Reason |
|---|---|
| All columns `STRING` in RAW | Preserves data exactly as received — no silent data loss |
| `ON_ERROR = CONTINUE` | Skips bad rows + logs errors, never silently drops data |
| Auto-suspend warehouse at 60s | Prevents idle credit burn |
| Never recreate Storage Integration | `EXTERNAL_ID` changes every time — breaks AWS Trust Policy |

### Checklist
- [x] AWS S3 bucket setup with 7 CSV files
- [x] IAM Role + Trust Policy configured
- [x] Snowflake Storage Integration (S3_INT)
- [x] Database, Warehouse, 3-Schema architecture
- [x] CSV File Format + External Stage
- [x] All 7 tables created and loaded via COPY INTO
- [x] Verified via `LOAD_HISTORY` — 0 errors

---

## 🔜 Layer 2 — STAGING (In Progress)

- [ ] Type casting all STRING columns to proper data types
- [ ] NULL handling and data quality checks
- [ ] Surrogate key generation
- [ ] Business logic and transformations

---

## 🔜 Layer 3 — REPORTING (Planned)

- [ ] Aggregated views for Power BI
- [ ] KPIs: Total Revenue, Returns Rate, Delivery Status
- [ ] Final star schema optimised for DAX queries

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| AWS S3 | Raw file storage |
| AWS IAM | Secure access via role assumption (STS) |
| Snowflake | Data warehouse — RAW → STAGING → REPORTING |
| Power BI | Dashboard and reporting layer |
| SQL | All pipeline logic and transformations |

---

> *"The fastest way to upskill is to build something that breaks — and then fix it."*
