-- THE COST OF BEING SUPER: POSTGRESQL SCHEMA INSPECTION
--
-- These read-only queries inspect the ACTUAL database schema.
-- This file is NOT a CREATE TABLE script, migration, or complete database rebuild.
-- Execute against the populated superhero_analysis PostgreSQL database.
--
-- Table and column metadata. Includes primary/foreign-key columns in all user tables.
SELECT
    table_name,
    ordinal_position,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- Primary-key and foreign-key constraints.
-- PostgreSQL system catalogs preserve the exact constraint definitions.
SELECT
    source_table.relname AS table_name,
    constraint_record.conname AS constraint_name,
    CASE constraint_record.contype
        WHEN 'p' THEN 'PRIMARY KEY'
        WHEN 'f' THEN 'FOREIGN KEY'
    END AS constraint_type,
    pg_get_constraintdef(constraint_record.oid) AS definition
FROM pg_constraint AS constraint_record
JOIN pg_class AS source_table
    ON source_table.oid = constraint_record.conrelid
JOIN pg_namespace AS table_namespace
    ON table_namespace.oid = source_table.relnamespace
WHERE table_namespace.nspname = 'public'
  AND constraint_record.contype IN ('p', 'f')
ORDER BY source_table.relname, constraint_type, constraint_name;

-- Row counts for the central operational tables.
-- Useful as a sanity check when examining a local copy of the database.
SELECT 'mission' AS table_name, COUNT(*) AS row_count FROM mission
UNION ALL
SELECT 'missionagents', COUNT(*) FROM missionagents
UNION ALL
SELECT 'villainmissions', COUNT(*) FROM villainmissions
UNION ALL
SELECT 'villains', COUNT(*) FROM villains
UNION ALL
SELECT 'agentmissioncostprofile', COUNT(*) FROM agentmissioncostprofile
ORDER BY table_name;

-- Known relationships used in the published analysis:
-- mission.missionid = missionagents.missionid
-- mission.missionid = villainmissions.missionid
-- villains.villainid = villainmissions.villainid
-- villaineventtype.eventtypeid = villainmissions.eventtypeid
-- agentmissioncostprofile matches missionagents.agent
--    AND mission.missiontype, to prevent join fanout.
--
-- Some source CSV files are included in data/, but the repository does not
-- claim to contain every input or a complete reproducible CREATE TABLE script.
