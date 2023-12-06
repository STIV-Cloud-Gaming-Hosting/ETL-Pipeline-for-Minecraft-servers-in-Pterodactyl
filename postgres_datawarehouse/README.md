# Data Warehouse with PostgreSQL

We chose to use PostgreSQL because it is self-hosted and free. While it is typically designed as a database, we find it useful to leverage it as a data warehouse in this specific context

## Schemas

The primary purpose of the schemas is to maintain distinct environments for each aspect of this project. The aforementioned design facilitates straightforward and efficient execution of queries within PostgreSQL. It also enables the subsequent visualization of data in a focused manner, free from interventions or data irrelevant to the specific information being sought.

### pterodactyl

Below is a table displaying all the tables within the `pterodactyl` schema:

| Table            | Description                                                    |
|------------------|----------------------------------------------------------------|
| `locations`      | It contains information about the locations of Pterodactyl.    |
| `nodes`          | These are Pterodactyl nodes.                                   |
| `allocations`    | It contains information about Pterodactyl allocations (ports). |
| `nests`          | It holds information about Pterodactyl nests.                  |
| `eggs`           | It contains information about the game eggs.                   |
| `servers`        | It contains information about the servers and establishes connections with most of the tables. |
| `clients`        | It holds customer (client) information.                        |
| `clients_server` | It contains information about the relationship between clients and servers in a many-to-many configuration. |
| `last_update`    | It provides information on the last time the previous tables were updated. |
| `utilization`    | It encompasses all the information related to resource consumption of every server. |

This schema is created based on [pterodactyl_application](/development_notebook/pterodactyl_application.ipynb) for most of the tables, and [pterodactyl_resource_consumption](/development_notebook/pterodactyl_resource_consumption.ipynb) is involved with the `utilization` table only.

### pterodactyl_update

This schema includes most of the tables as the `pterodactyl` schema, but with `_update` appended to their names. Its primary purpose is to act as auxiliar tables to update the data on `pterodactyl` schema. This approach improves performance compared to a for loop in the python script to update each row individually.

Below is a table displaying all the tables within the `pterodactyl_update` schema:

| Table                   | Description                                                            |
|-------------------------|------------------------------------------------------------------------|
| `locations_update`      | It serves as an auxiliary table for the `pterodactyl.locations` table. |
| `nodes_update`          | It serves as an auxiliary table for the `pterodactyl.nodes` table.     |
| `allocations_update`    | It serves as an auxiliary table for the `pterodactyl.allocations` table. |
| `nests_update`          | It serves as an auxiliary table for the `pterodactyl.nests` table.     |
| `eggs_update`           | It serves as an auxiliary table for the `pterodactyl.eggs` table.      |
| `servers_update`        | It serves as an auxiliary table for the `pterodactyl.servers` table.   |
| `clients_update`        | It serves as an auxiliary table for the `pterodactyl.clients` table.   |
| `clients_server_update` | It serves as an auxiliary table for the `pterodactyl.clients_server` table. |

The data in these tables is sourced from [pterodactyl_application](/development_notebook/pterodactyl_application.ipynb)

### minecraft

Below is a table displaying all the tables within the `minecraft` schema:

| Table            | Description                                               |
|------------------|-----------------------------------------------------------|
| `activity`       | It encompasses information regarding the activity of each user on their respective server. |

All the information in this schema is sourced from [pterodactyl_minecraft_logs](/development_notebook/pterodactyl_minecraft_logs.ipynb) 

## Data Modeling (pterodactyl)

For the `pterodactyl` schema, we adopted a structure resembling a star schema, with the `servers` table at the center. However, it's important to note that the `servers` table is not our fact table. The measurable data resides in the `utilization` table and the `activity` table across different schemas, such as the `activity` table in the `minecraft` schema.

This schema design is based on the data retrieved from the `Pterodactyl API` and serves as the foundation for our analyses, featuring numerous dimension tables.

Below, you can easily explore the relationships between the data. For more in-depth information, we recommend reviewing the various `.sql` files available here, as they all include comments on each table and attribute

![ERD/ERM](../images/ERD_pterodactyl.jpg)