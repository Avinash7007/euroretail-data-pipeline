-- ============================================================
--  03_file_format_stage.sql
--  STEP 3: CSV File Format + External Stage
--  Run as: ACCOUNTADMIN
-- ============================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE EURORETAIL_DB;
USE SCHEMA RAW;
USE WAREHOUSE EURORETAIL_WH;

-- Define how Snowflake should parse the CSV files
CREATE OR REPLACE FILE FORMAT EURORETAIL_DB.RAW.CSV_FORMAT
    TYPE                         = CSV
    FIELD_DELIMITER              = ','
    SKIP_HEADER                  = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF                      = ('NULL', '')
    EMPTY_FIELD_AS_NULL          = TRUE
    TRIM_SPACE                   = TRUE;

-- External stage pointing directly to S3 bucket
CREATE OR REPLACE STAGE EURORETAIL_DB.RAW.RAW_STAGE
    URL                 = 's3://euro-retails/raw/'
    STORAGE_INTEGRATION = S3_INT
    FILE_FORMAT         = EURORETAIL_DB.RAW.CSV_FORMAT;

-- Test: all 7 CSV files should be listed here
LIST @EURORETAIL_DB.RAW.RAW_STAGE;
