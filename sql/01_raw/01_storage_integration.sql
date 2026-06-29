-- ============================================================
--  01_storage_integration.sql
--  STEP 1: Snowflake ↔ AWS S3 Connection
--  Run as: ACCOUNTADMIN
-- ============================================================

USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE STORAGE INTEGRATION S3_INT
    TYPE                      = EXTERNAL_STAGE
    STORAGE_PROVIDER          = S3
    ENABLED                   = TRUE
    STORAGE_ALLOWED_LOCATIONS = ('s3://euro-retails/raw/')
    STORAGE_AWS_ROLE_ARN      = 'arn:aws:iam::<your-account-id>:role/snowflake-aws-role';

-- Run this and copy both values into AWS IAM Trust Policy:
--   STORAGE_AWS_IAM_USER_ARN  → Principal → AWS
--   STORAGE_AWS_EXTERNAL_ID   → Condition → sts:ExternalId
DESC INTEGRATION S3_INT;

-- ⚠️  WARNING: Never DROP + RECREATE this integration unnecessarily.
--              EXTERNAL_ID changes every time → AWS Trust Policy must be updated again.
