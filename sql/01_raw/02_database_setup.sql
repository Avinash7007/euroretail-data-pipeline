-- ============================================================
--  02_database_setup.sql
--  STEP 2: Database, Warehouse & Schema Setup
--  Run as: ACCOUNTADMIN
-- ============================================================

USE ROLE ACCOUNTADMIN;

-- Main database
CREATE DATABASE IF NOT EXISTS EURORETAIL_DB;
USE DATABASE EURORETAIL_DB;

-- Small warehouse — auto-suspends after 60s to prevent idle credit burn
CREATE WAREHOUSE IF NOT EXISTS EURORETAIL_WH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND   = 60
    AUTO_RESUME    = TRUE;

USE WAREHOUSE EURORETAIL_WH;

-- Three-layer architecture
CREATE SCHEMA IF NOT EXISTS RAW;        -- Raw data as-is from S3 (no transformation)
CREATE SCHEMA IF NOT EXISTS STAGING;    -- Cleaned, typed, business logic applied
CREATE SCHEMA IF NOT EXISTS REPORTING;  -- Aggregated views for Power BI
