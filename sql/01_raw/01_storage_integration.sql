-- ============================================================
-- 01_storage_integration.sql
-- STEP 1: Snowflake <-> AWS S3 secure integration
-- Bootstrap: ACCOUNTADMIN (or a role with CREATE INTEGRATION)
-- ============================================================

USE ROLE ACCOUNTADMIN;

-- IMPORTANT:
-- 1. Replace <AWS_ACCOUNT_ID> and <IAM_ROLE_NAME> before first run.
-- 2. Do NOT use CREATE OR REPLACE here after the integration is linked
--    to a stage. Replacing an integration changes its hidden identity
--    and can break existing stage associations.
-- 3. For an existing integration, use the ALTER statement below.

CREATE STORAGE INTEGRATION IF NOT EXISTS S3_INT
    TYPE                      = EXTERNAL_STAGE
    STORAGE_PROVIDER          = S3
    ENABLED                   = TRUE
    STORAGE_ALLOWED_LOCATIONS = ('s3://euro-retails/raw/')
    STORAGE_AWS_ROLE_ARN      = 'arn:aws:iam::<AWS_ACCOUNT_ID>:role/<IAM_ROLE_NAME>'
    COMMENT                   = 'EuroRetail secure S3 integration';

-- If the integration already exists and its IAM role or allowed path
-- needs to change, use ALTER instead of recreating the integration:
--
-- ALTER STORAGE INTEGRATION S3_INT SET
--     STORAGE_AWS_ROLE_ARN      = 'arn:aws:iam::<AWS_ACCOUNT_ID>:role/<IAM_ROLE_NAME>'
--     STORAGE_ALLOWED_LOCATIONS = ('s3://euro-retails/raw/')
--     ENABLED = TRUE;

-- Capture these values for the AWS IAM trust policy.
DESC INTEGRATION S3_INT;

-- Optional connectivity validation after the AWS trust policy is ready.
-- SELECT SYSTEM$VALIDATE_STORAGE_INTEGRATION(
--     'S3_INT',
--     's3://euro-retails/raw/',
--     'integration_validation.txt',
--     'LIST'
-- );
