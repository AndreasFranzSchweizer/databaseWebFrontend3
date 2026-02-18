\set ON_ERROR_STOP on

-- optional: alte DBs weg (robust)
DROP DATABASE IF EXISTS bundesliga22;
DROP DATABASE IF EXISTS mondial;

-- User anlegen (idempotent)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'webfrontend') THEN
    CREATE USER webfrontend WITH PASSWORD 'web';
  END IF;
END$$;

-- harte Leitplanken für den Demo-User (global)
ALTER ROLE webfrontend SET statement_timeout = '2s';
ALTER ROLE webfrontend SET lock_timeout = '1s';
ALTER ROLE webfrontend SET idle_in_transaction_session_timeout = '5s';
ALTER ROLE webfrontend SET default_transaction_read_only = on;

-- ================= bundesliga =================
DROP DATABASE IF EXISTS bundesliga;
CREATE DATABASE bundesliga;
\c bundesliga
\i bundesliga24_25.sql

GRANT CONNECT ON DATABASE bundesliga TO webfrontend;
GRANT USAGE ON SCHEMA public TO webfrontend;
GRANT SELECT ON ALL TABLES    IN SCHEMA public TO webfrontend;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES    TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO webfrontend;

-- ================= fahrradverleih =================
DROP DATABASE IF EXISTS fahrradverleih;
CREATE DATABASE fahrradverleih;
\c fahrradverleih
\i fahrradverleih.psql

GRANT CONNECT ON DATABASE fahrradverleih TO webfrontend;
GRANT USAGE ON SCHEMA public TO webfrontend;
GRANT SELECT ON ALL TABLES    IN SCHEMA public TO webfrontend;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES    TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO webfrontend;

-- ================= hotel =================
DROP DATABASE IF EXISTS hotel;
CREATE DATABASE hotel;
\c hotel
\i hotel.sql

GRANT CONNECT ON DATABASE hotel TO webfrontend;
GRANT USAGE ON SCHEMA public TO webfrontend;
GRANT SELECT ON ALL TABLES    IN SCHEMA public TO webfrontend;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES    TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO webfrontend;

-- ================= streamingdienst =================
DROP DATABASE IF EXISTS streamingdienst;
CREATE DATABASE streamingdienst;
\c streamingdienst
\i streamingdienst.psql

GRANT CONNECT ON DATABASE streamingdienst TO webfrontend;
GRANT USAGE ON SCHEMA public TO webfrontend;
GRANT SELECT ON ALL TABLES    IN SCHEMA public TO webfrontend;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES    TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO webfrontend;

-- ================= solar =================
DROP DATABASE IF EXISTS solar;
CREATE DATABASE solar;
\c solar
\i pvpower.sql

GRANT CONNECT ON DATABASE solar TO webfrontend;
GRANT USAGE ON SCHEMA public TO webfrontend;
GRANT SELECT ON ALL TABLES    IN SCHEMA public TO webfrontend;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES    TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO webfrontend;

-- ================= worldoffisicraft =================
DROP DATABASE IF EXISTS worldoffisicraft;
CREATE DATABASE worldoffisicraft;
\c worldoffisicraft
\i worldoffisicraft.sql

GRANT CONNECT ON DATABASE worldoffisicraft TO webfrontend;
GRANT USAGE ON SCHEMA public TO webfrontend;
GRANT SELECT ON ALL TABLES    IN SCHEMA public TO webfrontend;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES    TO webfrontend;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO webfrontend;
