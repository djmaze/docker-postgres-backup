#!/usr/bin/env bash
set -eou pipefail

OUTPUT_FOLDER=/tmp/backup
OUTPUT_FILE="${OUTPUT_FOLDER}/backup_$(date +%u).sql.gz.age"

if [[ -z "${RECIPIENT:-}" ]]; then
  >&2 echo "Error - need RECIPIENT"
  exit 1
fi

if [[ -z "${RCLONE_TARGET:-}" ]]; then
  >&2 echo "Error – need RCLONE_TARGET"
  exit 1
fi

>&2 echo Starting backup..

mkdir "$OUTPUT_FOLDER"
set +e
(pg_dump "$DATABASE_URL" \
  | gzip - \
  | age --encrypt --recipient "${RECIPIENT}" --output "${OUTPUT_FILE}" \
  ) \
  2>&1 | tee /tmp/error_output
rc=$?
set -e

if [[ "$rc" == 0 ]]; then
  >&2 echo "Backup successful."
  ls -hl "${OUTPUT_FOLDER}"

  set +e
  rclone copy "${OUTPUT_FOLDER}" "${RCLONE_TARGET}" 2>&1 | tee /tmp/error_output
  rc=$?
  set -e

  if [[ "$rc" == 0 ]]; then
    >&2 echo "Upload successful."

    if [[ -n "${HEALTHCHECKS_URL:-}" ]]; then
      curl -fsS -m 10 --retry 5 "${HEALTHCHECKS_URL}"
    fi
  else
    >&2 echo "Upload failed!"
    if [[ -n "${HEALTHCHECKS_URL:-}" ]]; then
      curl -fsS -m 10 --retry 5 -d @/tmp/error_output "${HEALTHCHECKS_URL}/fail"
  fi
    exit $rc
  fi
else
  >&2 echo "Backup failed!"
  if [[ -n "${HEALTHCHECKS_URL:-}" ]]; then
    curl -fsS -m 10 --retry 5 -d @/tmp/error_output "${HEALTHCHECKS_URL}/fail"
  fi
  exit $rc
fi
