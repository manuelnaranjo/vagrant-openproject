# vagrant-openproject

Vagrant receipe for an OpenProject virtual machine

# Usage

This receipe is quite easy to use:

    $ git clone https://github.com/idbaigorria/vagrant-openproject.git
    $ cd vagrant-openproject
    $ vagrant up

Now you can point your browser to http://localhost:8211

# Configuration

The receipe can be configured to match your needs, this can be done after you
executed the previous steps

## Plugins

You can check etc/install/Gemfile.plugins if you want to get more plugins
installed. After that you need to run:

    $ vagrant provision

## Installing extra programs

You can install extra programs into your vm by editing etc/install/install.sh,
follow the code pattern as it will work with vagrant provision.

    $ vagrant provision
