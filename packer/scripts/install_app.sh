#!/bin/bash
mkdir /usr/local/otus-reddit-app && cd /usr/local/otus-reddit-app/
apt -y install git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
