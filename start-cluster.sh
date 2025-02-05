#!/bin/bash

# The default node number is 3
N=${1:-3}

# Call the resize-number-slaves.sh with the number of slaves as an argument
./resize-number-slaves.sh "$N"

# Create hadoop network
docker network create --driver=bridge hadoop-network >/dev/null 2>&1 || true

# Start Hadoop master container
echo "Starting namhy-master container..."
docker rm -f namhy-master >/dev/null 2>&1 || true
docker run -itd \
    --net=hadoop-network \
    --name namhy-master \
    --hostname namhy-master \
    namhy/hadoop-master >/dev/null 2>&1

# Start Hadoop slave containers
i=1
while [ $i -lt "$N" ]; do
    echo "Starting namhy-slave$i container..."
    docker rm -f namhy-slave$i >/dev/null 2>&1 || true
    docker run -itd \
        --net=hadoop-network \
        --name namhy-slave$i \
        --hostname namhy-slave$i \
        namhy/hadoop-slave >/dev/null 2>&1
    i=$((i + 1))
done

# Get into the Hadoop master container
docker start -i namhy-master
