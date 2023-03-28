sudo apt-get -y install pgbackrest jq
PGBACKREST_PATH="/etc/pgbackrest.conf"
PGBACKREST_REPO="/var/lib/pgbackrest"
COMPRESS_LEVEL="3"
REPO1_RETENTION_FULL="2"
REPO_ENCRYPTION=$(sudo -u postgres bash -c "openssl rand -base64 48")
POSTGRES_DATA=$(sudo su - postgres -c "psql -t -P format=unaligned -c 'SHOW data_directory';")
sudo -u postgres bash -c "cat <<EOF> /etc/pgbackrest.conf
[db-primary]
pg1-path=$POSTGRES_DATA
[global]
repo1-bundle=y
repo1-path=$PGBACKREST_REPO
repo1-retention-full=$REPO1_RETENTION_FULL
repo1-cipher-pass= $REPO_ENCRYPTION
repo1-cipher-type= aes-256-cbc
start-fast=y
archive-async=y
spool-path=/var/spool/pgbackrest
archive-timeout=10000

[global:archive-push]
compress-level=$COMPRESS_LEVEL
compress-type=lz4
[global:archive-get]
process-max=2
EOF"

if (${gcp} -eq true)
then
sudo -u postgres bash -c "cat <<EOF>> /etc/pgbackrest.conf
repo1-type=gcs
repo1-gcs-bucket=${bucket}
repo1-gcs-key-type=auto
EOF"
else
  sudo -u postgres bash -c "cat <<EOF>> /etc/pgbackrest.conf

repo1-s3-bucket=${bucket}
repo1-s3-endpoint=${endpoint}
repo1-s3-region=${region}
repo1-s3-key-type=auto
repo1-s3-role=timescale-role
repo1-type=s3
EOF"
fi


sudo -u postgres pgbackrest --stanza=db-primary --log-level-console=info stanza-create
sudo systemctl enable cron

sudo -u postgres bash -c "(crontab -l 2>/dev/null || true; echo \"30 06  *   *   0     pgbackrest --type=full --stanza=db-primary backup\") | crontab -"
sudo -u postgres bash -c "(crontab -l 2>/dev/null|| true; echo \"30 06  *   *   1-6   pgbackrest --type=diff --stanza=db-primary backup\") | crontab -"



