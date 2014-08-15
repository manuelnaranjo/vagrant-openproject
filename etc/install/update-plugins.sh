#!/usr/bin/bash

# This script will update openproject plugins

cp /vagrant/etc/install/Gemfile.plugins /opt/openproject/

openproject run bundle install --no-deployment
openproject run rake db:migrate
openproject run rake assets:precompile

service openproject restart
