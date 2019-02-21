# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'
GUEST_CODE_FOLDER = '~/vagrant/code'
HOST_CODE_FOLDER = '/home/vagrant/code'

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
# Vagrant.configure("2") do |config|
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # Use Ubuntu 16.04 LTS because that is what the code is currently validated against
  # config.vm.box = "ubuntu/xenial64" # Ubuntu 16.04
  config.vm.box = "ubuntu/bionic64" # Ubuntu 18.04

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = true

  # Run the setup bash script
  config.vm.provision "shell", path: "setup.sh"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share additional folders to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.

  # Share the host machine's SSH keys and known_hosts
  config.vm.synced_folder "~/.ssh/", "/root/.hostssh"
  
  # Share code on the VM with the host machine
  config.vm.synced_folder GUEST_CODE_FOLDER, HOST_CODE_FOLDER

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  config.vm.provider "virtualbox" do |vm|
    # Display the VirtualBox GUI when booting the machine
    # vm.gui = true
  
    # Customize memory and CPUs
    vm.memory = 2048
    vm.cpus   = 2
    # Shortcuts for:
    # config.vm.customize ["modifyvm", :id, "--memory", 2048]
    # config.vm.customize ["modifyvm", :id, "--cpus",   2]

    # Set execution cap
    vm.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

end
