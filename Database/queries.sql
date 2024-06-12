DROP SCHEMA IF EXISTS lake CASCADE;

CREATE SCHEMA IF NOT EXISTS lake
AUTHORIZATION postgres; 

--creation of enums


CREATE TYPE  Role AS ENUM ('ADMIN', 'USER');
CREATE TYPE Provider AS ENUM ('GOOGLE', 'LOCAL');
CREATE TYPE AlertSeverity AS ENUM ('INFO','WARNING','CRITICAL');
CREATE TYPE AlertType  AS ENUM ('TEMP','WEIGHT','TILT','SENSOR');



CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--creation of tables
CREATE TABLE lake.user (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255),
    provider Provider NOT NULL,
    createdAt TIMESTAMP ,
    updatedAt TIMESTAMP,
    role Role,
    notified BOOLEAN
);

CREATE TABLE lake.hive (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        createdAt TIMESTAMP,
        updatedAt TIMESTAMP,
        description TEXT DEFAULT '',
        userId UUID NOT NULL,
        name VARCHAR(255) UNIQUE NOT NULL,
        userHasAccess BOOLEAN,
        --status Status DEFAULT 'ACTIVE',
        CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE lake.hive_data (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        createdAt TIMESTAMP,
        hiveId UUID NOT NULL,
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
        time TEXT,
        CONSTRAINT fk_hive FOREIGN KEY (hiveId) REFERENCES Hive (id) ON DELETE CASCADE
);


CREATE TABLE lake.session (
        sid VARCHAR(255) PRIMARY KEY DEFAULT uuid_generate_v4(),
        sess TEXT NOT NULL,
        expire TIMESTAMP(6) NOT NULL
);

CREATE TABLE lake.alert (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  hiveId UUID NOT NULL,
  message TEXT NOT NULL,
  type AlertType NOT NULL,
  severity AlertSeverity NOT NULL,
  CONSTRAINT fk_hive FOREIGN KEY (hiveId) REFERENCES Hive(id) ON DELETE CASCADE
);



CREATE TABLE lake."prisma_migrations" (
	id varchar(36) NOT NULL,
	checksum varchar(64) NOT NULL,
	finished_at timestamptz NULL,
	migration_name varchar(255) NOT NULL,
	logs text NULL,
	rolled_back_at timestamptz NULL,
	started_at timestamptz DEFAULT now() NOT NULL,
	applied_steps_count int4 DEFAULT 0 NOT NULL,
	CONSTRAINT "_prisma_migrations_pkey" PRIMARY KEY (id)
);