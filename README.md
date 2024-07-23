# Docker Postgres backup

[![Build Status](https://ci.strahlungsfrei.de/api/badges/djmaze/docker-postgres-backup/status.svg)](https://ci.strahlungsfrei.de/djmaze/docker-postgres-backup)
[![Docker Stars](https://img.shields.io/docker/stars/decentralize/postgres-backup.svg)](https://hub.docker.com/r/decentralize/postgres-backup/) [![Docker Pulls](https://img.shields.io/docker/pulls/decentralize/postgres-backup.svg)](https://hub.docker.com/r/decentralize/postgres-backup/)

This Docker image allows making a full SQL backup of a postgres database and store it [Age](https://github.com/FiloSottile/age)-encrypted on a remote location supported by rclone.

The backup is encrypted asymmetrically, so you need to supply a public key. The holder of the private key will be able to decrypt the backup.

## Usage

Create a new keypair using `age-keygen`. Store the keyfile in a secure location and run this container with the `RECIPIENT` env variable set to the public key.

See [docker-compose.yml](docker-compose.yml) for an example which stores the backup using S3 on a local minio server.

You can also supply a [Healthchecks](https://healthchecks.io/) ping URL in order to be notified of backup success and failure.
