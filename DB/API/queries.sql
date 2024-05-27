DROP SCHEMA IF EXISTS lake CASCADE;

CREATE SCHEMA IF NOT EXISTS lake
AUTHORIZATION postgres; 

--creation of enums


CREATE TYPE  Role AS ENUM ('ADMIN', 'USER');
CREATE TYPE Provider AS ENUM ('GOOGLE', 'LOCAL');
CREATE TYPE Status AS ENUM ('ACTIVE', 'DELETED', 'DESACTIVATED');

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--creation of tables
CREATE TABLE lake.user (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255),
    provider Provider NOT NULL,
    createdAt TIMESTAMP DEFAULT now(),
    updatedAt TIMESTAMP DEFAULT now(),
    role Role DEFAULT 'USER',
    notified BOOLEAN DEFAULT TRUE
);

CREATE TABLE lake.hive (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        createdAt TIMESTAMP DEFAULT now(),
        updatedAt TIMESTAMP DEFAULT now(),
        description TEXT DEFAULT '',
        userId UUID NOT NULL,
        name VARCHAR(255) UNIQUE NOT NULL,
        userHasAccess BOOLEAN DEFAULT TRUE,
        --status Status DEFAULT 'ACTIVE',
        CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE lake.hive_data (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        createdAt TIMESTAMP DEFAULT now(),
        hiveId UUID NOT NULL,
        weight FLOAT DEFAULT 0,
        inclination BOOLEAN DEFAULT FALSE,
        humidity FLOAT DEFAULT 0,
        temperature FLOAT DEFAULT 0,
        CONSTRAINT fk_hive FOREIGN KEY (hiveId) REFERENCES Hive (id) ON DELETE CASCADE
);


CREATE TABLE lake.session (
        sid VARCHAR(255) PRIMARY KEY DEFAULT uuid_generate_v4(),
        sess TEXT NOT NULL,
        expire TIMESTAMP(6) NOT NULL
);
