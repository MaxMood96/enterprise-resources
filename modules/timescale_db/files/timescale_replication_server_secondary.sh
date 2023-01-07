${prepend_userdata}


apt install -y gnupg postgresql-common apt-transport-https lsb-release wget
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/timescaledb.gpg
/usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
sudo echo "deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -c -s) main" | sudo tee /etc/apt/sources.list.d/timescaledb.list
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt update
apt install -y timescaledb-2-postgresql-14
timescaledb-tune --quiet --yes
apt install postgresql-client
systemctl restart postgresql
timescaledb-tune --quiet --yes


sudo -u postgres bash -c 'createuser codecov --superuser'
sudo -u postgres psql -c "ALTER USER codecov PASSWORD '${timescale_password}';"
sudo -u postgres bash -c "createuser replication --replication --login --connection-limit=1;"
sudo -u postgres psql -c "ALTER USER replication PASSWORD '${timescale_password}';"
sudo -u postgres bash -c "echo $HOSTNAME:5432:postgres:replication:${timescale_password} >> .pgpass"
HBA_CONF=$(sudo su - postgres -c "psql -t -P format=unaligned -c 'show hba_file';")
sudo -u postgres bash -c "cat <<EOF>>$HBA_CONF
 host replication  replication ${IP_RANGE}    md5
 host all all 0.0.0.0/0 md5
EOF"
POSTGRES_CONF=$(sudo su - postgres -c "psql -t -P format=unaligned -c 'SHOW config_file';")
POSTGRES_DATA=$(sudo su - postgres -c "psql -t -P format=unaligned -c 'SHOW data_directory';")

sudo -u postgres bash -c "cat <<EOF>> $POSTGRES_CONF
listen_addresses = '*'
hot_standby = on
primary_conninfo= 'host=${MasterIP} port=5432 user=replication password=${timescale_password}'
primary_slot_name = 'db02_repl_slot'
EOF"

  COUNTER=0
  echo 'Waiting for postgresql to start ...'
while [ -z "`nc -vz ${MasterIP} 5432 2>&1 | grep succeeded`" ]; do

    COUNTER=$(($COUNTER+1))
    if [ "$COUNTER" -gt 30 ]; then
      echo "Timeout waiting for postgresql on ${MasterIP} to start"
      exit 1
    elif [ "$COUNTER" -eq 15 ]; then
      echo 'Still waiting for postgresql on ${MasterIP} to start ...'
    fi
    sleep 1
  done

systemctl stop postgresql@14-main.service
cd $POSTGRES_DATA
rm -rf *

sudo -u postgres bash -c "pg_basebackup -h ${MasterIP} -D $POSTGRES_DATA -w -P -R -U replication --wal-method=fetch"

systemctl start postgresql@14-main.service


