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

-- CREATE ANALYSIS VIEW

CREATE OR REPLACE VIEW minecraft.last_log_date
AS
	SELECT
		activity.server_identifier,
    	max(activity.date) AS last_date
	FROM minecraft.activity
  	GROUP BY activity.server_identifier;

CREATE OR REPLACE VIEW minecraft.activity_analysis
AS (
    SELECT
		s.identifier,
        s.name,
        COUNT(DISTINCT CASE WHEN a."user" <> 'server' THEN a."user" END) AS total_users,
        COUNT(a.activity) AS total_activity,
        COUNT(DISTINCT CASE WHEN a.date >= CURRENT_DATE - INTERVAL '7 days' AND a."user" <> 'server' THEN a."user" END) AS last_week_active_users,
        COUNT(CASE WHEN a.date >= CURRENT_DATE - INTERVAL '7 days' THEN a.activity END) AS last_week_activity,
        COUNT(DISTINCT CASE WHEN a.date >= CURRENT_DATE - INTERVAL '30 days' AND a."user" <> 'server' THEN a."user" END) AS last_month_active_users,
        COUNT(CASE WHEN a.date >= CURRENT_DATE - INTERVAL '30 days' THEN a.activity END) AS last_month_activity,
        MAX(a.date) AS last_activity_date
    FROM minecraft.activity AS a
    INNER JOIN pterodactyl.servers AS s
        ON a.server_identifier = s.identifier
    GROUP BY s.identifier, s.name
);