#!/bin/bash

# Tag images
docker tag backend-backend kamulizila/backend-backend
docker tag backend-worker kamulizila/backend-worker
docker tag backend-beat kamulizila/backend-beat
docker tag backend-vue-frontend kamulizila/backend-vue-frontend
docker tag backend-backup kamulizila/backend-backup

# Push images
docker push kamulizila/backend-backend
docker push kamulizila/backend-worker
docker push kamulizila/backend-beat
docker push kamulizila/backend-vue-frontend
docker push kamulizila/backend-backup
