-- CREATE SCHEMA 
CREATE SCHEMA minecraft;

-- TABLES FOR MINECRAFT LOGS

CREATE TABLE minecraft.activity (
	id SERIAL PRIMARY KEY,
	server_identifier VARCHAR(8) NOT NULL REFERENCES pterodactyl.servers(identifier),
	date DATE NOT NULL,
	time TIME NOT NULL,
	information text,
	"user" VARCHAR(50),
	activity VARCHAR(6)
);