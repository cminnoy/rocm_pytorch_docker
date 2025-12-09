#!/bin/bash
set -e
docker compose -f "$(dirname "$0")/docker-compose.yml" up -d
