# Architecture & Design Decisions

## Overview

This pipeline follows a **3-layer medallion architecture** inside Snowflake:

```
S3 → RAW → STAGING → REPORTING → Power BI
```

Each layer has one clear responsibility. Data flows in one direction only.

---

## Layer 1 — RAW

**Purpose:** Ingest from S3 exactly as-is. Zero transformations.

**Rules:**
- All columns are `STRING` — no type casting at this stage
- `ON_ERROR = CONTINUE` — bad rows are skipped and logged, not dropped
- Raw tables are the source of truth for debugging

**Why STRING columns?**
If a source file has a bad value like `"29-Feb-2023"` and we cast directly to `DATE`, the row silently drops or the entire load fails. STRING columns in RAW mean we always have the original value to debug against. Casting happens in STAGING with full visibility.

---

## Layer 2 — STAGING *(coming soon)*

Planned:
- Cast STRING columns to proper types (DATE, NUMBER, INTEGER)
- NULL handling with business rules
- Surrogate key generation
- Business logic (net sales after discount, etc.)

---

## Layer 3 — REPORTING *(coming soon)*

Planned:
- Aggregated views for Power BI
- KPIs: Revenue, Returns Rate, Delivery Status
- Star schema optimised for DAX queries

---

## AWS + Snowflake Integration

```
Snowflake → assumes → IAM Role (snowflake-aws-role)
                           ↓
                     reads S3 (euro-retails/raw/)
```

**Critical:** Every `CREATE OR REPLACE STORAGE INTEGRATION` generates a new `STORAGE_AWS_EXTERNAL_ID`. AWS Trust Policy must be updated with this new value every time — otherwise the stage silently fails.

---

## Cost Management

Warehouse: `XSMALL` with `AUTO_SUSPEND = 60s`

Auto-suspend ensures the warehouse stops after 60 seconds of inactivity — preventing idle credit burn between pipeline runs.
