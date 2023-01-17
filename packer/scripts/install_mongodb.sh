#!/bin/bash
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt update
sleep 10
apt install -y mongodb-org
cat /etc/mongod.conf  | sed 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' > /etc/mongod.conf.new
mv /etc/mongod.conf.new /etc/mongod.conf
systemctl start mongod
systemctl enable mongod
systemctl status mongod
