# How to use the project with Jupyter Notebook (development)

This project comprises several pipelines, which are outlined in the development notebook folder, the usage of each pipeline is detailed in the section [Detailed explanation of each pipeline](#detailed-explanation-of-each-pipeline)

## Context and different types of loads

Before utilizing this project, please ensure that you have set up your own `.env` file. You can use `.env.example` as a template by copying it and then configuring your specific environment variables in the newly created `.env` file. Additionally, make sure to install the libraries listed in `requirements.txt` before using the notebooks.

Below, you will find a table detailing various types of data loads along with their explanations. Familiarizing yourself with this information will be beneficial as you proceed through the documentation.

| Type of Load                  | Description                                               |
|-------------------------------|-----------------------------------------------------------|
| `FULL LOAD`                   | Completely replaces the existing data in the target system with a fresh copy from the source, ensuring an exact replica. |
| `FULL LOAD with SOFT DELETE`  | Similar to a FULL LOAD, but instead of physically deleting data, it updates a status field to indicate whether a record is active or not. Retains a historical perspective while refreshing data. |
| `INCREMENTAL LOAD`            | Adds only new data from the source since the last load, reducing processing time and resources. |
| `AGGREGATED LOAD`             | Involves loading pre-aggregated (summarized) data into the target system, streamlining processing for reporting and analytics purposes. |

## Summary

### pterodactyl_application

This process is `FULL LOAD with SOFT DELETE`, and involves the schema `pterodactyl` with following tables:
- locations
- nodes
- allocations
- nests
- eggs
- servers
- clients
- clients_server
- last_update

> For this pipeline, the schmea `pterodactyl_update` is used to easily apply the `SOFT DELETE` part of the load to Postgres.

### pterodactyl_minecraft_logs

This process is `INCREMENTAL LOAD`, and involves the schema `pterodactyl` with following tables:
- activity

### pterodactyl_consumption

This process is `INCREMENTAL AGGREGATED LOAD`, and involves the schema `pterodactyl` with following tables:
- utilization

## Detailed explanation of each pipeline

It is essential to clarify that there are two sections shared among the `.ipynb` files; the section for importing libraries and setting up keys, and the section to define functions, variables, and setup directories.

The first section aims to import the necessary libraries for each file and to set up the variables required for connecting to both the PostgreSQL database and the Pterodactyl APIs.

The second section is designated for storing the necessary functions to ensure proper functionality and for creating the required directories. It's important to note that all data used for connections must be stored in an .env file, which should be created with your credentials (either username and password or an API key). This ensures that no errors occur when the program connects to these resources.

### pterodactyl_application

Skipping the first two sections, we delve into "Get Pterodactyl Application Information." In this phase, we establish a connection with the Pterodactyl application to download data related to clients, locations, nodes, eggs, nests, and servers using list comprehensions. After storing the obtained data in variables, a cleaning process ensues, filtering only the desired columns for each of the ensuing dataframes. Subsequently, each of the created dataframes is exported in .csv format.

The final section, "Upload CSV Table Files into PostgreSQL" commences with the creation of a loop. Following this, we set the variables according to our SQL database specifications to retrieve IDs from PostgreSQL. These IDs are then compared with the ones present in the dataframes saved as .csv files. The next step involves establishing a connection with the PostgreSQL database, where decisions are made regarding which files to upload, update, or ~~delete~~ mark as "not active" based on the earlier comparisons of IDs. Once the actions to be performed are determined, SQL queries are executed to facilitate the ingestion, update, or deletion of data in the PostgreSQL database.

> This process is `FULL LOAD with SOFT DELETE`.

### pterodactyl_minecraft_logs

This segment constitutes the lengthiest code section in the notebook. It begins with "Extracting Logs from Each Active Minecraft Server", where we initiate a connection to PostgreSQL. Utilizing a SQL query, we extract the requisite data. Following this extraction, we conduct a test to identify if the eggs in our database are included in the 'eggs ready' list, as our current support may not encompass all available Minecraft eggs. Subsequently, we get user cache from the client API and add only those users who are absent in the CSV file.

Next, we define 'last_log_date,' which resides in the SQL database. If there is no last log entry due to a new server or egg, it is automatically set to a really old date to facilitate subsequent download of logs for these new servers. Employing the 'last_log_date' in conjunction with the 'sorted_list_logs' function, we selectively download only the logs from the specified date. This approach minimizes the download of unnecessary files already present in the SQL database. Finally, the files are decompressed based on their compression type, which currently includes .gz and .zip formats.

The "Transformation from Logs Data to Information" section aims to convert recently acquired information into a more streamlined and useful format. All logs are parsed, and variables are generated to store pertinent details. The focal point of this section is to define the types of activities that we wish to see in our SQL database. This categorization is determined based on the extracted activity information from each log. For instance, if a segment of the information indicates 'Starting Minecraft server version' it will be transformed into 'start' accompanied by the user who executed the activity. This process simplifies the information provided by Minecraft, offering a clearer perspective on user activities within the servers. Finally, all the refined information is stored in a designated variable.

The final section, "Load Processed Data into Data Warehouse (PostgreSQL)" differs from the section with a similar name in 'pterodactyl_application'. In this section, we directly take the variable created earlier and upload it to the PostgreSQL database. Consequently, this section is notably straightforward, making it the easiest to comprehend and utilize.

> This process is `INCREMENTAL LOAD`.

### pterodactyl_consumption

Within this code, excluding the initial three sections, the focal point is "Get Pterodactyl Utilization Information". Here, we first define crucial variables such as WINDOW_EXTRACTION_TIME, BREAK_TIME, and WAITING_TIME. These variables play a significant role as this pipeline is designed to execute the code repeatedly within a specified time frame. The objective is to extract multiple sets of data systematically, enabling the calculation of averages for each dataset, which are then uploaded to the database.

Subsequently, we proceed to extract the UUIDs of servers from the SQL database using a query. Using a loop, coupled with time intervals defined by the aforementioned variables, we extract data from servers listed in the server UUIDs. Finally, a dataframe is generated, encapsulating information with averages calculated for each column as defined in the process.

The "Load Data into Data Warehouse (PostgreSQL)" section mirrors the one utilized in the preceding pipeline. Therefore, we will not elaborate further, simply noting that in this segment, data is loaded from the previously created dataframe into the PostgreSQL database.

> This process is `INCREMENTAL AGGREGATED LOAD`.

## More details about the tables

You can find more information about tables in Postgres in the folowing directory: [postgres_datawarehouse](/postgres_datawarehouse)