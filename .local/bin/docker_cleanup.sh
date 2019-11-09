#!/bin/bash
set -eux

docker container prune -f
docker image prune -f
