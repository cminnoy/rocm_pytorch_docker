#!/bin/bash
set -e
docker compose exec --user ubuntu --workdir /workspaces rocm-pytorch bash -c "source /opt/venv/bin/activate && exec bash"
