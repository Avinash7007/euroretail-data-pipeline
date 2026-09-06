# STAGING Layer

Views that convert RAW's source-aligned STRING columns into typed, analytics-ready data.

- `01_staging_views.sql` — `TRY_TO_*` conversions, NULL normalization, and SHA-256 surrogate keys for the seven core tables.
- `02_data_quality_checks.sql` — assertions on required identifiers, dates, numeric fields, and foreign-key references. A healthy run returns `PASS` for every check.
