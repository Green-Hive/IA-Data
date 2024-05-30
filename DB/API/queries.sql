DROP SCHEMA IF EXISTS lake CASCADE;

CREATE SCHEMA IF NOT EXISTS lake
AUTHORIZATION postgres; 

--creation of enums


CREATE TYPE  Role AS ENUM ('ADMIN', 'USER');
CREATE TYPE Provider AS ENUM ('GOOGLE', 'LOCAL');

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--creation of tables
CREATE TABLE lake.user (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255),
    provider Provider NOT NULL,
    notified BOOLEAN,
    createdAt TIMESTAMP ,
    updatedAt TIMESTAMP,
    role Role
);

CREATE TABLE lake.hive (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        createdAt TIMEST AMP,
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
        hiveId TEXT NOT NULL,
        tempBottomLeft FLOAT,
        tempTopRight FLOAT,
        tempOutside FLOAT,
        pressure FLOAT,
        humidityBottomLeft FLOAT,
        humidityTopRight FLOAT,
        humidityOutside FLOAT,
        weight FLOAT,
        magnetic_x FLOAT,
        magnetic_y FLOAT,
        magnetic_z FLOAT
        CONSTRAINT fk_hive FOREIGN KEY (hiveId) REFERENCES Hive (id) ON DELETE CASCADE
);


CREATE TABLE lake.session (
        sid VARCHAR(255) PRIMARY KEY DEFAULT uuid_generate_v4(),
        sess TEXT NOT NULL,
        expire TIMESTAMP(6) NOT NULL
);
