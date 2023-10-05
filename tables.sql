-- CREATE SCHEMA 
CREATE SCHEMA pterodactyl;

-- TABLES FROM PTERODACTYL APP DATA

CREATE TABLE pterodactyl.locations (
	id int8 PRIMARY KEY,
	short text NOT NULL,
	long float8 NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.nests (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	author text NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.eggs (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	nest_id int8 NOT NULL,
	author text NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.nodes (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	public bool NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	location_id int8 NOT NULL,
	fqdn text NOT NULL,
	scheme text NOT NULL,
	behind_proxy bool NOT NULL,
	maintenance_mode bool NOT NULL,
	memory int8 NOT NULL,
	disk int8 NOT NULL,
	allocated_memory int8 NOT NULL,
	allocated_disk int8 NOT NULL,
	upload_size int8 NOT NULL,
	daemon_listen int8 NOT NULL,
	daemon_sftp int8 NOT NULL,
	daemon_base text NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.servers (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	identifier text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	limit_memory int8 NOT NULL,
	limit_disk int8 NOT NULL,
	limit_io int8 NOT NULL,
	limit_cpu int8 NOT NULL,
	limit_oom_disable bool NULL,
	limit_database int8 NULL,
	limit_allocation int8 NULL,
	limit_backup int8 NULL,
	client_id int8 NOT NULL,
	node_id int8 NOT NULL,
	allocation_id int8 NOT NULL,
	nest_id int8 NOT NULL,
	egg_id int8 NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.clients (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	client_name text NOT NULL,
	email text NOT NULL,
	first_name text NULL,
	last_name text NULL,
	"admin" bool NOT NULL,
	"2fa" bool NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.clients_server (
	id int8 PRIMARY KEY,
	client_id int8 NOT NULL,
	server_id int8 NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

-- TABLES_UPDATE FROM PTERODACTYL APP DATA

CREATE TABLE pterodactyl.locations_update (
	id int8 PRIMARY KEY,
	short text NOT NULL,
	long float8 NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

CREATE TABLE pterodactyl.nests_update (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	author text NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

CREATE TABLE pterodactyl.eggs_update (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	nest_id int8 NOT NULL,
	author text NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

CREATE TABLE pterodactyl.nodes_update (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	public bool NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	location_id int8 NOT NULL,
	fqdn text NOT NULL,
	scheme text NOT NULL,
	behind_proxy bool NOT NULL,
	maintenance_mode bool NOT NULL,
	memory int8 NOT NULL,
	disk int8 NOT NULL,
	allocated_memory int8 NOT NULL,
	allocated_disk int8 NOT NULL,
	upload_size int8 NOT NULL,
	daemon_listen int8 NOT NULL,
	daemon_sftp int8 NOT NULL,
	daemon_base text NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

CREATE TABLE pterodactyl.servers_update (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	identifier text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	limit_memory int8 NOT NULL,
	limit_disk int8 NOT NULL,
	limit_io int8 NOT NULL,
	limit_cpu int8 NOT NULL,
	limit_oom_disable bool NULL,
	limit_database int8 NULL,
	limit_allocation int8 NULL,
	limit_backup int8 NULL,
	client_id int8 NOT NULL,
	node_id int8 NOT NULL,
	allocation_id int8 NOT NULL,
	nest_id int8 NOT NULL,
	egg_id int8 NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

CREATE TABLE pterodactyl.clients_update (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	client_name text NOT NULL,
	email text NOT NULL,
	first_name text NULL,
	last_name text NULL,
	"admin" bool NOT NULL,
	"2fa" bool NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

CREATE TABLE pterodactyl.clients_server_update (
	id int8 PRIMARY KEY,
	client_id int8 NOT NULL,
	server_id int8 NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

-- IS_ACTIVE_TABLE TO KEEP OLD DATA IN DB

CREATE TABLE pterodactyl.is_active_table (
	id int8 NOT NULL
);

-- LAST_UPDATE TO KNOW THE LAST TIME THE DATA WAS UPDATED

CREATE TABLE pterodactyl.last_update (
	date timestamptz NOT NULL
);

-- CREATE TABLES
CREATE TABLE pterodactyl.activity (
	id SERIAL PRIMARY KEY, --id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 ),
	server_id VARCHAR(8) NOT NULL,
	date DATE NOT NULL,
	time TIME NOT NULL,
	information VARCHAR(100),
	"user" VARCHAR(50),
	activity VARCHAR(6)
);

-- CREATE ANALYSIS VIEW
CREATE OR REPLACE VIEW pterodactyl.activity_analysis
AS (
    SELECT s.identifier,
        s.name,
        COUNT(DISTINCT CASE WHEN a."user" <> 'server' THEN a."user" END) AS total_users,
        COUNT(a.activity) AS total_activity,
        COUNT(DISTINCT CASE WHEN a.date >= CURRENT_DATE - INTERVAL '7 days' AND a."user" <> 'server' THEN a."user" END) AS last_week_active_users,
        COUNT(CASE WHEN a.date >= CURRENT_DATE - INTERVAL '7 days' THEN a.activity END) AS last_week_activity,
        COUNT(DISTINCT CASE WHEN a.date >= CURRENT_DATE - INTERVAL '30 days' AND a."user" <> 'server' THEN a."user" END) AS last_month_active_users,
        COUNT(CASE WHEN a.date >= CURRENT_DATE - INTERVAL '30 days' THEN a.activity END) AS last_month_activity,
        MAX(a.date) AS last_activity_date
    FROM pterodactyl.activity AS a
    INNER JOIN pterodactyl.servers AS s
        ON a.server_id = s.identifier
    GROUP BY s.identifier
);