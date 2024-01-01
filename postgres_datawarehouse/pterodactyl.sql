-- CREATE SCHEMA 
CREATE SCHEMA pterodactyl;

-- TABLES FOR PTERODACTYL APP DATA

CREATE TABLE pterodactyl.locations (
	id int8 PRIMARY KEY,
	short text NOT NULL,
	long text NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.nests (
	id int8 PRIMARY KEY,
	uuid text NOT NULL UNIQUE,
	"name" text NOT NULL,
	description text NULL,
	author text NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.eggs (
	id int8 PRIMARY KEY,
	uuid text NOT NULL UNIQUE,
	"name" text NOT NULL,
	description text NULL,
	nest_id int8 NOT NULL REFERENCES pterodactyl.nests(id),
	author text NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.nodes (
	id int8 PRIMARY KEY,
	uuid text NOT NULL UNIQUE,
	public bool NOT NULL,
	"name" text NOT NULL,
	description text NULL,
    location_id int8 NOT NULL REFERENCES pterodactyl.locations(id),
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
    node_id int8 NOT NULL REFERENCES pterodactyl.nodes(id),
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.servers (
	id int8 PRIMARY KEY,
	uuid text NOT NULL UNIQUE,
	identifier text NOT NULL UNIQUE,
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
	client_id int8 NOT NULL REFERENCES pterodactyl.clients(id),
    node_id int8 NOT NULL REFERENCES pterodactyl.nodes(id),
    allocation_id int8 NOT NULL REFERENCES pterodactyl.allocations(id),
    nest_id int8 NOT NULL REFERENCES pterodactyl.nests(id),
    egg_id int8 NOT NULL REFERENCES pterodactyl.eggs(id),
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL
);

CREATE TABLE pterodactyl.clients (
	id int8 PRIMARY KEY,
	uuid text NOT NULL UNIQUE,
	client_name text NOT NULL,
	email text NOT NULL UNIQUE,
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
	client_id int8 NOT NULL REFERENCES pterodactyl.clients(id),
    server_id int8 NOT NULL REFERENCES pterodactyl.servers(id),
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	is_active bool DEFAULT true NOT NULL
);

CREATE TABLE pterodactyl.utilization (
	server_identifier text NOT NULL REFERENCES pterodactyl.servers(identifier),
	status bool NOT NULL,
	ram_mean numeric(10, 2) NOT NULL,
	ram_std numeric(10, 2),
	ram_min numeric(10, 2) NOT NULL,
	ram_max numeric(10, 2) NOT NULL,
	cpu_mean numeric(8, 2) NOT NULL,
	cpu_std numeric(8, 2),
	cpu_min numeric(8, 2) NOT NULL,
	cpu_max numeric(8, 2) NOT NULL,
	disk_mean numeric(11, 2) NOT NULL,
	disk_std numeric(11, 2),
	disk_min numeric(11, 2) NOT NULL,
	disk_max numeric(11, 2) NOT NULL,
	capture_time timestamptz NOT NULL
);

-- LAST_UPDATE TO KNOW THE LAST TIME THE DATA WAS UPDATED

CREATE TABLE pterodactyl.last_update (
	date timestamptz NOT NULL
);