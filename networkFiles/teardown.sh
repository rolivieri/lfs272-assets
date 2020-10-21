#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Shut down the Docker containers for the system tests.
docker-compose -f docker-compose.yml kill && docker-compose -f docker-compose.yml down

# Remove chaincode Docker images
#docker ps --filter name=NAMEHERE* -aq | xargs docker stop | xargs docker rm
#docker rmi $(docker images dev-* -q)

# Your system is now clean
