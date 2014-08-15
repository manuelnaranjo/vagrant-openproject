#!/usr/bin/bash

DATE=`date +%d%m%Y-%H%M%S`

pg_dump -U openproject openproject > /vagrant/dumps/openproject-${DATE}.sql
