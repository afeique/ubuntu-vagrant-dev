#!/bin/bash
# Author: Afeique Sheikh
# Description: Setup script for Ubuntu LTS Vagrant

# THIS FILE IS RUN AS ROOT BY VAGRANT
# hence the lack of sudo before apt-get calls, the use of /root directory, etc.

# REQUIRED: set git information
GIT_NAME=''
GIT_USER=''
GIT_EMAIL=''

# This folder is created at the very end.
# It should match the GUEST_HOST_FOLDER in the Vagrantfile.
# This folder will be synced with a folder on the host.
# This is so code can be modified directly using an IDE on the host.
CODE_FOLDER='/home/vagrant/code'

# See: https://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
export DEBIAN_FRONTEND=noninteractive

apt-get update

# Install requisite packages for git, php, docker
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04
# See also: https://gist.github.com/ryu22e/462976ca1c74c61c9f18
echo "-- Installing dependencies"
apt-get -y install \
  git \
  make \
  curl \
  iputils-ping \
  smbclient \
  sshpass \
  docker.io \
  unzip \

# Install PHP and required extensions on composer
echo "-- Installing PHP and extensions"
sudo apt-get -y install \
  php \
  php-cli \
  php-zip \
  php-xml \
  php-curl \
  php-soap \
  php-mbstring \

# Install Miniconda, Python 3.7
echo "-- Installing Miniconda to /opt/conda"
# Download QUIETLY
wget -q http://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# Make bash script installer executable
chmod +x Miniconda3-latest-Linux-x86_64.sh
# Modify PREFIX= to set /opt/conda as install path (rather than $HOME/miniconda3 default)
# sed -i 's/^PREFIX=\$HOME\/miniconda3$/PREFIX=\/opt\/conda/' Miniconda3-latest-Linux-x86_64.sh
# Install Miniconda to /opt/conda without manual intervention (-b for batch operation)
bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda
# Copy basic symlinks to /usr/local/bin
cd /opt/conda/bin
cp conda activate deactivate /usr/local/bin
cd /root

# Add insecure docker registries here
if [ -e "/etc/docker/daemon.json" ]; then
  echo "-- /etc/docker/daemon.json already exists"
else
  echo "-- Creating /etc/docker/daemon.json with insecure registries"
  echo -e \
    '{\n  "insecure-registries": []\n}' > daemon.json
  mv daemon.json /etc/docker
fi

# Restart docker for changes to take effect
service docker restart

# Add vagrant user to docker group, so sudo is not necessary for using docker
usermod -aG docker vagrant

# Setup your git configuration
echo "-- Setting git globals"
git config --global user.name $GIT_NAME
git config --global user.email $GIT_EMAIL

# Ensure .ssh directory exists for vagrant user
mkdir -p /home/vagrant/.ssh

# Copy the host machine's SSH public/private keys into the VM
# This way, the VM can auth as the developer on datto gitlab
if [ ! -e /root/.ssh/id_rsa.pub ]; then
  echo "-- Copying public key id_rsa.pub from host"
  cp /root/.hostssh/id_rsa.pub /root/.ssh
  cp /root/.hostssh/id_rsa.pub /home/vagrant/.ssh
  cat /home/vagrant/.ssh/id_rsa.pub
fi

if [ ! -e /root/.ssh/id_rsa ]; then
  echo "-- Copying private key id_rsa from host"
  cp /root/.hostssh/id_rsa /root/.ssh
  cp /root/.hostssh/id_rsa /home/vagrant/.ssh
  cat /home/vagrant/.ssh/id_rsa
fi

# Ensure composer is installed and updated
# See: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-composer-on-ubuntu-16-04
if [ -x "$(which composer)" ]; then
  echo "-- Updating composer"
  composer self-update
else
  # Setup composer; this does NOT verify the hash/integrity
  # https://getcomposer.org/download/
  echo "-- Installing composer"
  curl -sS https://getcomposer.org/installer -o composer-setup.php
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer
  rm composer-setup.php
fi

echo "-- Creating $CODE_FOLDER"
mkdir -p $CODE_FOLDER
chown -R vagrant:vagrant $CODE_FOLDER

