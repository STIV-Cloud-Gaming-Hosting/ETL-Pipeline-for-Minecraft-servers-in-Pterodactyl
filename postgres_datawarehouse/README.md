# Data Warehouse with PostgreSQL

We chose to use PostgreSQL because it is self-hosted and free. While it is typically designed as a database, we find it useful to leverage it as a data warehouse in this specific context

## Schemas

[Brief description]
The primary purpose of the schemas is to maintain distinct environments for each aspect of this project. The aforementioned design facilitates straightforward and efficient execution of queries within PostgreSQL. It also enables the subsequent visualization of data in a focused manner, free from interventions or data irrelevant to the specific information being sought.

### pterodactyl

| Table                 | Description                                               |
|-------------------------------|-----------------------------------------------------------|
| `locations`             | It contains information about the locations of Pterodactyl. |
| `nodes`             | These are Pterodactyl nodes. |
| `allocations`             | It contains information about Pterodactyl allocations. |
| `nests`             | It holds information about Pterodactyl nests. |
| `eggs`             | It contains information about the game eggs. |
| `servers`                   | It contains information about the servers and establishes connections with most of the tables. |
| `clients`  | It holds customer information. |
| `clients_server`            | It provides information regarding the servers for each client. |
| `last_update`             | It provides information on the last update of the database. |
| `utilization`             | It encompasses all the information related to resource consumption. |

This schema is created based on  [pterodactyl_application](/development_notebook/pterodactyl_application.ipynb) and [pterodactyl_resource_consumption](/development_notebook/pterodactyl_resource_consumption.ipynb)

### pterodactyl_update

This schema includes the same tables as the previous schema, but with '_update' appended to their names. Its primary purpose is to store information about the latest update times for each table in the 'pterodactyl' schema. This ensures that only entirely new information is added.

The data in these tables is sourced from [pterodactyl_application](/development_notebook/pterodactyl_application.ipynb)

### minecraft


| Table                 | Description                                               |
|-------------------------------|-----------------------------------------------------------|
| `activity`             | It encompasses information regarding the activity of each user on their respective server. |

All the information in this schema is sourced from [pterodactyl_minecraft_logs](/development_notebook/pterodactyl_minecraft_logs.ipynb) 

## Data Modeling (pterodactyl)

For the `pterodactyl` schema, we adopted a structure resembling a star schema, with the `servers` table at the center. However, it's important to note that the `servers` table is not our fact table. The measurable data resides in the `utilization` table and the `activity` table across different schemas, such as the `activity` table in the `minecraft` schema.

This schema design is based on the data retrieved from the `Pterodactyl API` and serves as the foundation for our analyses, featuring numerous dimension tables.

Below, you can easily explore the relationships between the data. For more in-depth information, we recommend reviewing the various `.sql` files available here, as they all include comments on each table and attribute

![ERD/ERM](../images/ERD_pterodactyl.jpg)