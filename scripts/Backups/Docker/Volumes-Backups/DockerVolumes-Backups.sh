#!/bin/bash

APPS_FOLDER="/docker/apps"
VOLUMES_FOLDER="./volumes"
DESTINY_FOLDER="./destiny"
TIMESTAMP=$(date +%d-%m-%Y-%H%M)
LOG_FOLDER="./logs"
LOG_FILE="docker-volumes-backups.log"
LOGS="$LOG_FOLDER/$LOG_FILE"

mkdir -p "$LOG_FOLDER" "$DESTINY_FOLDER"

#Save working containers list
running_containers=$(docker ps -q)

# Stop services
docker stop $running_containers
echo "Docker containers stopped at $TIMESTAMP" >> "$LOGS"

# Backup volumes
for volume in $VOLUMES_FOLDER/*; do
    volume_name=$(basename "$volume")
    tar -czf "$DESTINY_FOLDER/${volume_name}_$TIMESTAMP.tar.gz" -C "$VOLUMES_FOLDER" "$volume_name"
    echo "Backup of $volume_name completed at $TIMESTAMP" >> "$LOGS"
done

# Turn on previous running containers
docker start $running_containers
echo "Docker containers started at $TIMESTAMP" >> "$LOGS"
