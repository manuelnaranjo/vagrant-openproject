#!/bin/bash

set -ex

# Installation settings
PROJECT_NAME=$1
PROJECT_DIR=/home/vagrant/$PROJECT_NAME

PGSQL_VERSION=9.1

if [ ! -f /home/vagrant/.locales ]; then
    # Need to fix locale so that Postgres creates databases in UTF-8
    cp -p $PROJECT_DIR/etc/install/etc-bash.bashrc /etc/bash.bashrc
    locale-gen en_GB.UTF-8
    dpkg-reconfigure locales
    touch /home/vagrant/.locales
fi

export LANGUAGE=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

wget -qO - https://deb.packager.io/key | sudo apt-key add -
echo "deb https://deb.packager.io/gh/tessi/openproject precise feature/pkgr" | sudo tee /etc/apt/sources.list.d/openproject.list

# Install essential packages from Apt
sudo apt-get update -y

# Postgresql
if ! command -v psql; then
    apt-get install -y postgresql-$PGSQL_VERSION libpq-dev

    cp $PROJECT_DIR/etc/install/pg_hba.conf \
        /etc/postgresql/$PGSQL_VERSION/main/
        /etc/init.d/postgresql reload
fi


# Git (we'd rather avoid people keeping credentials for git commits
# in the repo, but sometimes we need it for pip requirements that
# aren't in PyPI)
if ! command -v git ; then
    apt-get install -y git
fi

# mcedit
if ! command -v mcedit; then
    apt-get install -y mc
fi

# now install openproject
if ! command -v openproject; then
    sudo apt-get install -y openproject*=3.0.1-1400061402.f476e5c.precise

    # create dabase
    sudo -u postgress createdb openproject

    # configure openproject
    sudo openproject config:set SECRET_TOKEN=$(sudo openproject run rake secret | tail -1)
    sudo openproject config:set DATABASE_URL=postgres://postgress@localhost/openproject

    # run initialization
    sudo openproject run rake db:migrate
    sudo openproject run rake db:seed
    sudo openproject scale web=1 worker=1
    sudo service openproject restart
fi

if [ -f $PROJECT_DIR/etc/install/Gemfile.plugins ]; then
    # initialize plugins
    sudo cp $PROJECT_DIR/etc/install/Gemfile.plugins /opt/openproject/

    sudo openproject run bundle install --no-deployment
    sudo openproject run rake db:migrate
    sudo openproject run rake assets:precompile
    sudo service openproject restart
fi
