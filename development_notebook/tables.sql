-- CREATE SCHEMA 
CREATE SCHEMA pterodactyl;
CREATE SCHEMA pterodactyl_update;

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

CREATE TABLE pterodactyl.allocations (
	id int8 PRIMARY KEY,
	port int4 NOT NULL,
	assigned bool NOT NULL,
	node_id int8 NOT NULL,
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

CREATE TABLE pterodactyl_update.locations_update (
	id int8 PRIMARY KEY,
	short text NOT NULL,
	long float8 NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

CREATE TABLE pterodactyl_update.nests_update (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	author text NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

CREATE TABLE pterodactyl_update.eggs_update (
	id int8 PRIMARY KEY,
	uuid text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	nest_id int8 NOT NULL,
	author text NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

CREATE TABLE pterodactyl_update.nodes_update (
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

CREATE TABLE pterodactyl_update.allocations_update (
	id int8 PRIMARY KEY,
	port int4 NOT NULL,
	assigned bool NOT NULL,
	node_id int8 NOT NULL
);

CREATE TABLE pterodactyl_update.servers_update (
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

CREATE TABLE pterodactyl_update.clients_update (
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

CREATE TABLE pterodactyl_update.clients_server_update (
	id int8 PRIMARY KEY,
	client_id int8 NOT NULL,
	server_id int8 NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

-- IS_ACTIVE_TABLE TO KEEP OLD DATA IN DB

CREATE TABLE pterodactyl_update.is_active_table (
	id int8 NOT NULL
);

-- LAST_UPDATE TO KNOW THE LAST TIME THE DATA WAS UPDATED

CREATE TABLE pterodactyl.last_update (
	date timestamptz NOT NULL
);

-- CREATE TABLES

CREATE TABLE pterodactyl.activity (
	id SERIAL PRIMARY KEY,
	server_id VARCHAR(8) NOT NULL,
	date DATE NOT NULL,
	time TIME NOT NULL,
	information text,
	"user" VARCHAR(50),
	activity VARCHAR(6)
);

CREATE TABLE pterodactyl.utilization (
	identifier text NOT NULL,
	status bool NOT NULL,
	ram_mean numeric(9, 2) NOT NULL,
	ram_std numeric(9, 2),
	ram_min numeric(9, 2) NOT NULL,
	ram_max numeric(9, 2) NOT NULL,
	cpu_mean numeric(7, 2) NOT NULL,
	cpu_std numeric(7, 2),
	cpu_min numeric(7, 2) NOT NULL,
	cpu_max numeric(7, 2) NOT NULL,
	disk_mean numeric(10, 2) NOT NULL,
	disk_std numeric(10, 2),
	disk_min numeric(10, 2) NOT NULL,
	disk_max numeric(10, 2) NOT NULL,
	capture_time timestamptz NOT NULL
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
    GROUP BY s.identifier, s.name
);
