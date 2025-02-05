#!/bin/bash

# Build Docker images
docker build -t namhy/hadoop-master ./master
docker build -t namhy/hadoop-slave ./slave

# Remove old master container if exists
docker rm -f namhy-master

# Run master container
docker run -it \
  --name namhy-master \
  --hostname namhy-master \
  --network hadoop-network \
  --network-alias namhy-master \
  namhy/hadoop-master

# Remove old slave container if exists
docker rm -f namhy-slave1

# Run slave container
docker run -d \
  --name namhy-slave1 \
  --hostname namhy-slave1 \
  --network hadoop-network \
  --network-alias namhy-slave1 \
  namhy/hadoop-slave
