-- CREATE SCHEMA 
CREATE SCHEMA pterodactyl_update;

-- TABLES_UPDATE FROM PTERODACTYL APP DATA

CREATE TABLE pterodactyl_update.locations_update (
	id int8 PRIMARY KEY,
	short text NOT NULL,
	long text NULL,
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

