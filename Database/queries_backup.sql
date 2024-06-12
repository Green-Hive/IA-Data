
-- Création du schéma

CREATE SCHEMA IF NOT EXISTS backup_lake
AUTHORIZATION postgres;


CREATE TYPE  Role AS ENUM ('ADMIN', 'USER');
CREATE TYPE Provider AS ENUM ('GOOGLE', 'LOCAL');
CREATE TYPE AlertSeverity AS ENUM ('INFO','WARNING','CRITICAL');
CREATE TYPE AlertType  AS ENUM ('TEMP','WEIGHT','TILT','SENSOR');

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- Table user
CREATE TABLE IF NOT EXISTS backup_lake.user_backup (
    backupDate DATE ,
    id uuid,
    email VARCHAR(255),
    name VARCHAR(255),
    password VARCHAR(255),
    provider Provider NOT NULL,
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP,
    role Role,
    notified BOOLEAN
);

-- Table hive
CREATE TABLE IF NOT EXISTS backup_lake.hive_backup (
    backupDate DATE ,
    id UUID ,
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP,
    description TEXT DEFAULT '',
    userId UUID,
    name VARCHAR(255),
    userHasAccess BOOLEAN
);

-- Table hive_data
CREATE TABLE IF NOT EXISTS backup_lake.hive_data_backup (
    backupDate DATE,
    id UUID,
    createdAt TIMESTAMP,
    hiveId UUID,
    weight FLOAT,
    humidityBottomLeft FLOAT,
    humidityOutside FLOAT,
    humidityTopRight FLOAT,
    magnetic_x FLOAT,
    magnetic_y FLOAT,
    magnetic_z FLOAT,
    pressure FLOAT,
    tempBottomLeft FLOAT,
    tempOutside FLOAT,
    tempTopRight FLOAT,
    time TEXT
);

-- Table session
CREATE TABLE IF NOT EXISTS backup_lake.session_backup (
    backupDate DATE ,
    sid VARCHAR(255),
    sess TEXT NOT NULL,
    expire TIMESTAMP(6) NOT NULL
);

-- Table alert
CREATE TABLE IF NOT EXISTS backup_lake.alert_backup (
    backupDate DATE ,
    id UUID,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    hiveId UUID,
    message TEXT NOT NULL,
    type AlertType NOT NULL,
    severity AlertSeverity NOT NULL
);

-- Table prisma_migrations
CREATE TABLE IF NOT EXISTS backup_lake.prisma_migrations_backup (
    backupDate DATE ,
    id VARCHAR(36),
    checksum VARCHAR(64),
    finished_at TIMESTAMPTZ NULL,
    migration_name VARCHAR(255) NOT NULL,
    logs TEXT NULL,
    rolled_back_at TIMESTAMPTZ NULL,
    started_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    applied_steps_count INT DEFAULT 0 NOT NULL
);
