#!/bin/bash

# Check if the user has provided the node number
if [ -z "$1" ]; then
  echo "Please specify the node number of the Hadoop cluster!"
  exit 1
fi

# Get the node number
N=$1

# Change slaves file
WORKERS_FILE="master/config/workers"
rm -f "$WORKERS_FILE"

i=1
while [ $i -le $N ]; do
  echo "namhy-slave$i" >> "$WORKERS_FILE"
  i=$((i + 1))
done

echo
echo "Build Docker Hadoop image"
echo

# Rebuild namhy/hadoop-master image
docker build -t namhy/hadoop-master ./master

echo
