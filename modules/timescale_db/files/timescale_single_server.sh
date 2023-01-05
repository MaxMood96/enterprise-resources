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
systemctl restart postgresql@14-main.service



sudo -u postgres bash -c 'createuser codecov --superuser'
sudo -u postgres psql -c "ALTER USER codecov PASSWORD '${timescale_password}';"
HBA_CONF=$(sudo su - postgres -c "psql -t -P format=unaligned -c 'show hba_file';")
sudo -u postgres bash -c "echo host all all 0.0.0.0/0 md5 >> $HBA_CONF"
POSTGRES_CONF=$(sudo su - postgres -c "psql -t -P format=unaligned -c 'SHOW config_file';")
sudo -u postgres bash -c "echo listen_addresses = \'*\' >> $POSTGRES_CONF"
systemctl restart postgresql@14-main.service