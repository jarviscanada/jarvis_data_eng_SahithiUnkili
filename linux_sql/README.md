# Introduction

This project builds a lightweight monitoring agent that collects both hardware specifications and real-time system usage data from Linux machines. The goal is to provide continuous visibility into server performance using simple and efficient tools.

The system is designed for system administrators or infrastructure teams who need a basic monitoring solution without relying on heavy external tools. It uses Bash scripts to collect system metrics and stores the data in a PostgreSQL database running inside a Docker container.

The project separates static hardware information from dynamic usage data, which helps avoid redundancy and improves data organization. The main technologies used include Bash scripting, Docker, PostgreSQL, Git, and Linux commands such as lscpu, vmstat, and df.

# Quick Start

```bash
# Start PostgreSQL container
bash scripts/psql_docker.sh start

# Create tables
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql

# Insert hardware data (run once)
bash scripts/host_info.sh localhost 5432 host_agent postgres password

# Insert usage data (manual run)
bash scripts/host_usage.sh localhost 5432 host_agent postgres password

# Setup cron job
crontab -e

#Implementation
Architecture

The system follows a simple monitoring architecture:

Each Linux machine runs monitoring scripts
Scripts collect system data using Bash
Data is sent to a centralized PostgreSQL database
The database runs inside a Docker container

Data flow:
Linux Host ? Bash Scripts ? PostgreSQL Database

The architecture diagram (3 hosts + DB) is stored in the assets folder.

#Scripts
psql_docker.sh
This script is used to create, start, and stop the PostgreSQL container.
bash scripts/psql_docker.sh create|start|stop

host_info.sh
Collects hardware specifications such as CPU, memory, and system architecture. This script runs once per machine.
bash scripts/host_info.sh <host> <port> <db> <user> <password>

host_usage.sh
Collects real-time system metrics such as CPU usage, memory usage, and disk space.
bash scripts/host_usage.sh <host> <port> <db> <user> <password>

crontab
Used to automate execution of the usage script every minute.
* * * * * bash /path/to/host_usage.sh localhost 5432 host_agent postgres password

queries.sql
This file contains SQL queries used to analyze system performance trends,
 such as identifying high CPU usage or low memory situations.


## Database Modeling

### host_info
-----------------------------------------------------------
| Column            | Description                          |
|-------------------|--------------------------------------|
| id                | Unique ID for each host              |
| hostname          | Machine hostname                     |
| cpu_number        | Number of CPU cores                  |
| cpu_architecture  | CPU architecture                     |
| cpu_model         | CPU model name                       |
| cpu_mhz           | CPU speed in MHz                     |
| l2_cache          | L2 cache size                        |
| total_mem         | Total memory                         |
| timestamp         | Record creation time                 |
------------------------------------------------------------

### host_usage
-----------------------------------------------------------
| Column           | Description                          |
|------------------|--------------------------------------|
| timestamp        | Time of data collection              |
| host_id          | Reference to host_info               |
| memory_free      | Available memory                     |
| cpu_idle         | CPU idle percentage                  |
| cpu_kernel       | CPU kernel usage                     |
| disk_io          | Disk I/O                             |
| disk_available   | Available disk space                 |
-----------------------------------------------------------


#Test

The system was tested by running each script and verifying database results:

1.ddl.sql was executed and tables were created successfully
2.host_info.sh inserted hardware data correctly
3.host_usage.sh inserted real-time usage data
4.Foreign key relationship between tables was verified
5.Cron job was configured and new data was inserted every minute
6.Results were validated using SQL queries

#Deployment

The project was deployed using:

- Docker to run PostgreSQL database
- Bash scripts to collect system data
- Crontab to automate data collection
- GitHub for version control

Once deployed, the monitoring agent runs automatically with minimal manual effort.

#Deployment

The project was deployed using:

- Docker to run PostgreSQL database
- Bash scripts to collect system data
- Crontab to automate data collection
- <img width="2158" height="729" alt="architecture" src="https://github.com/user-attachments/assets/508020d2-c5bf-4e05-80d1-5f060e4e38b6" />
GitHub for version control

Once deployed, the monitoring agent runs automatically with minimal manual effort.
