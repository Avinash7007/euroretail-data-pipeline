-- ============================================================
-- 02_database_setup.sql
-- STEP 2: Database, warehouse and schema setup
-- Bootstrap: SYSADMIN
-- ============================================================

USE ROLE SYSADMIN;

CREATE DATABASE IF NOT EXISTS EURORETAIL_DB;

CREATE WAREHOUSE IF NOT EXISTS EURORETAIL_WH
    WAREHOUSE_SIZE            = 'XSMALL'
    AUTO_SUSPEND              = 60
    AUTO_RESUME               = TRUE
    INITIALLY_SUSPENDED       = TRUE
    STATEMENT_TIMEOUT_IN_SECONDS = 3600
    COMMENT                   = 'EuroRetail ELT warehouse';

-- Keep warehouse configuration deterministic without recreating it.
ALTER WAREHOUSE EURORETAIL_WH SET
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    STATEMENT_TIMEOUT_IN_SECONDS = 3600;

CREATE SCHEMA IF NOT EXISTS EURORETAIL_DB.RAW
    COMMENT = 'Immutable source-aligned ingestion layer';

CREATE SCHEMA IF NOT EXISTS EURORETAIL_DB.STAGING
    COMMENT = 'Typed and quality-checked transformation layer';

CREATE SCHEMA IF NOT EXISTS EURORETAIL_DB.REPORTING
    COMMENT = 'Business-facing analytical views';

USE DATABASE EURORETAIL_DB;
USE WAREHOUSE EURORETAIL_WH;
