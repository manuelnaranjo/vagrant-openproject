#!/bin/env/env bash

service openproject stop

psql -U postgres <<EOF
DROP DATABASE openproject;
CREATE DATABASE openproject OWNER openproject;
EOF

psql -U openproject < ${1}
