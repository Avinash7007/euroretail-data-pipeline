-- ============================================================
--  05_load_data.sql
--  STEP 5: Load Data — S3 → RAW Tables via COPY INTO
--  Run as: ACCOUNTADMIN
--
--  ON_ERROR = CONTINUE:
--  Skips bad rows and continues loading.
--  All errors are logged in LOAD_HISTORY — nothing silently dropped.
-- ============================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE EURORETAIL_DB;
USE SCHEMA RAW;
USE WAREHOUSE EURORETAIL_WH;

-- ------------------------------------------------------------
-- DIMENSION TABLES
-- ------------------------------------------------------------

COPY INTO RAW.DIM_CUSTOMER
    FROM @EURORETAIL_DB.RAW.RAW_STAGE/dim_customer.csv
    FILE_FORMAT = EURORETAIL_DB.RAW.CSV_FORMAT
    ON_ERROR    = 'CONTINUE';

COPY INTO RAW.DIM_DATE
    FROM @EURORETAIL_DB.RAW.RAW_STAGE/dim_date.csv
    FILE_FORMAT = EURORETAIL_DB.RAW.CSV_FORMAT
    ON_ERROR    = 'CONTINUE';

COPY INTO RAW.DIM_PRODUCT
    FROM @EURORETAIL_DB.RAW.RAW_STAGE/dim_product.csv
    FILE_FORMAT = EURORETAIL_DB.RAW.CSV_FORMAT
    ON_ERROR    = 'CONTINUE';

COPY INTO RAW.DIM_STORE
    FROM @EURORETAIL_DB.RAW.RAW_STAGE/dim_store.csv
    FILE_FORMAT = EURORETAIL_DB.RAW.CSV_FORMAT
    ON_ERROR    = 'CONTINUE';

-- ------------------------------------------------------------
-- FACT TABLES
-- ------------------------------------------------------------

COPY INTO RAW.FACT_SALES
    FROM @EURORETAIL_DB.RAW.RAW_STAGE/fact_sales.csv
    FILE_FORMAT = EURORETAIL_DB.RAW.CSV_FORMAT
    ON_ERROR    = 'CONTINUE';

COPY INTO RAW.FACT_RETURNS
    FROM @EURORETAIL_DB.RAW.RAW_STAGE/fact_returns.csv
    FILE_FORMAT = EURORETAIL_DB.RAW.CSV_FORMAT
    ON_ERROR    = 'CONTINUE';

COPY INTO RAW.FACT_SHIPMENTS
    FROM @EURORETAIL_DB.RAW.RAW_STAGE/fact_shipments.csv
    FILE_FORMAT = EURORETAIL_DB.RAW.CSV_FORMAT
    ON_ERROR    = 'CONTINUE';
