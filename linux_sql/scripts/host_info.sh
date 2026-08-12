#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters"
  exit 1
fi

hostname=$(hostname -f)
lscpu_out=$(lscpu)

cpu_number=$(echo "$lscpu_out" | awk -F: '/^CPU\(s\):/ {print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | awk -F: '/^Architecture:/ {print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | awk -F: '/^Model name:/ {print $2}' | xargs)
cpu_mhz=$(echo "$cpu_model" | grep -oE '@ [0-9.]+GHz' | awk '{print $2}' | sed 's/GHz//' | awk '{print $1 * 1000}')

if [ -z "$cpu_mhz" ]; then
  cpu_mhz=0
fi
l2_cache=$(echo "$lscpu_out" | awk -F: '/^L2 cache:/ {print $2}' | awk '{print $1}' | xargs)
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}' | xargs)
timestamp=$(date -u +"%Y-%m-%d %H:%M:%S")

insert_stmt="INSERT INTO host_info(hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp) VALUES('$hostname', $cpu_number, '$cpu_architecture', '$cpu_model', $cpu_mhz, $l2_cache, $total_mem, '$timestamp');"
echo "$insert_stmt"
export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

exit $?
