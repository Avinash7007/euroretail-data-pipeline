-- ============================================================
--  04_raw_tables.sql
--  STEP 4: Create All 7 RAW Tables
--  Run as: ACCOUNTADMIN
--
--  Design Decision: ALL columns are STRING.
--  Raw layer preserves data exactly as received from S3.
--  Type casting happens in STAGING only — zero silent data loss.
-- ============================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE EURORETAIL_DB;
USE SCHEMA RAW;
USE WAREHOUSE EURORETAIL_WH;

-- ------------------------------------------------------------
-- DIMENSION TABLES
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE RAW.DIM_CUSTOMER (
    CUSTOMER_ID   STRING,
    CUSTOMER_NAME STRING,
    SEGMENT       STRING,
    CITY          STRING,
    REGION        STRING,
    COUNTRY       STRING
);

CREATE OR REPLACE TABLE RAW.DIM_DATE (
    DATE    STRING,
    YEAR    STRING,
    MONTH   STRING,
    QUARTER STRING
);

CREATE OR REPLACE TABLE RAW.DIM_PRODUCT (
    PRODUCT_ID   STRING,
    PRODUCT_NAME STRING,
    CATEGORY     STRING,
    SUB_CATEGORY STRING
);

CREATE OR REPLACE TABLE RAW.DIM_STORE (
    STORE_ID   STRING,
    STORE_NAME STRING,
    CITY       STRING,
    REGION     STRING,
    COUNTRY    STRING
);

-- ------------------------------------------------------------
-- FACT TABLES
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE RAW.FACT_SALES (
    ORDER_ID        STRING,
    ORDER_DATE      STRING,
    CUSTOMER_ID     STRING,
    PRODUCT_ID      STRING,
    STORE_ID        STRING,
    QUANTITY        STRING,
    UNIT_PRICE      STRING,
    GROSS_SALES     STRING,
    DISCOUNT_AMOUNT STRING,
    TOTAL_COST      STRING
);

CREATE OR REPLACE TABLE RAW.FACT_RETURNS (
    RETURN_ID     STRING,
    ORDER_ID      STRING,
    PRODUCT_ID    STRING,
    RETURN_DATE   STRING,
    RETURN_QTY    STRING,
    REFUND_AMOUNT STRING
);

CREATE OR REPLACE TABLE RAW.FACT_SHIPMENTS (
    SHIPMENT_ID     STRING,
    ORDER_ID        STRING,
    SHIP_DATE       STRING,
    SHIP_COST       STRING,
    DELIVERY_STATUS STRING
);
