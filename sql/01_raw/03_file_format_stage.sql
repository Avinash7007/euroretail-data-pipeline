-- ============================================================
-- 03_file_format_stage.sql
-- STEP 3: CSV file format and external S3 stage
-- Role: SYSADMIN (requires usage on S3_INT)
-- ============================================================

USE ROLE SYSADMIN;
USE DATABASE EURORETAIL_DB;
USE SCHEMA RAW;
USE WAREHOUSE EURORETAIL_WH;

-- The file format is safe to replace because it contains metadata only.
CREATE OR REPLACE FILE FORMAT EURORETAIL_DB.RAW.CSV_FORMAT
    TYPE                         = CSV
    FIELD_DELIMITER              = ','
    SKIP_HEADER                  = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF                      = ('NULL', '')
    EMPTY_FIELD_AS_NULL          = TRUE
    TRIM_SPACE                   = TRUE
    ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE
    COMMENT                      = 'EuroRetail source CSV format';

-- CREATE OR ALTER preserves the stage object instead of dropping it.
CREATE OR ALTER STAGE EURORETAIL_DB.RAW.RAW_STAGE
    URL                 = 's3://euro-retails/raw/'
    STORAGE_INTEGRATION = S3_INT
    FILE_FORMAT         = (FORMAT_NAME = 'EURORETAIL_DB.RAW.CSV_FORMAT')
    COMMENT             = 'External S3 landing stage for EuroRetail raw files';

-- Deployment smoke test: all expected source files should be present.
LIST @EURORETAIL_DB.RAW.RAW_STAGE;
