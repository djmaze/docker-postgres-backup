# Docker Postgres backup

This Docker image allows making a full SQL backup of a postgres database and store it GPG-encrypted on a remote location supported by rclone.

The backup is encrypted asymmetrically, so you need to supply a public key. The holder of the private key will be able to decrypt the backup.

## Usage

See [docker-compose.yml](docker-compose.yml) for an example which stores the backup using S3 on a local minio server.

You can also supply a [Healthchecks](https://healthchecks.io/) ping URL in order to be notified of backup success and failure.
