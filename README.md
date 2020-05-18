# Ubuntu Vagrant for Development

This Vagrantfile and associated shell scripts provision an Ubuntu LTS setup for development using [Vagrant]. This environment is aimed at PHP and Python development. It doesn't preinstall database packages, only programming languages. This makes it suitable as a base for running unit tests.

Using this guide, a consistent development environment can be setup on *any* operating system (Linux, OSX, Windows) in a matter of minutes.

## Requisites

* [VirtualBox] installed for your host platform
* [Vagrant] installed for your host platform
* SSH keys generated for your host and loaded onto your gitlab and okta accounts.
    * `ssh-keygen -t rsa -b 4096 -C "user@email.com"`
    * `cat ~/.ssh/id_rsa.pub`

## Methodology

These are the actual steps taken:

* Install PHP and extensions necessary for composer
* Install [Miniconda3] for Python3 development support
* Setup git user globals (`$GIT_NAME`, `$GIT_EMAIL`, `$GIT_USER`)
* Copy public, private keys from host machine into VM
* Install latest `composer`

For more information, read about [getting started with Vagrant].

## Setup

* Make a copy of the `Vagrantfile` and `setup.sh` in your work directory.
* Modify `Vagrantfile` and specify `HOST_CODE_FOLDER`: this is where code will be saved on your host machine. This defaults to `~/vagrant`. Ensure this directory exists.
* Modify `Vagrantfile` and specify `GUEST_CODE_FOLDER`: this is where you should save code on the guest OS/VM. Code in this folder will be synced to the `HOST_CODE_FOLDER`.
* Modify `setup.sh` and fill in the `$GIT_NAME`, `$GIT_EMAIL`, and `$GIT_USER` variables. These are setup for convenience.

## Vagrant VM

From the directory containing your `Vagrantfile` and `setup.sh`, run
    
    $ vagrant up                # create the VM and provision it
    $ vagrant global-status     # ensure the VM is running
    $ vagrant ssh               # ssh into the VM
    $ cd ~/code                 # cd into the directory code is located on the VM

From here, you should be able to run the various development tools on the VM and modify the code on the VM using your host IDE.

To destroy an existing VM, list it to the get the uuid and use `vagrant destroy`:

    $ vagrant global-status
    id       name    provider   state   directory                                    
    ---------------------------------------------------------------------------------
    5d8d809  default virtualbox running /Users/asheikh/code/siris-os-2/utils/vagrant 
     
    The above shows information about all known Vagrant environments
    on this machine. This data is cached and may not be completely
    up-to-date (use "vagrant global-status --prune" to prune invalid
    entries). To interact with any of the machines, you can go to that
    directory and run Vagrant, or you can use the ID directly with
    Vagrant commands from any directory. For example:
    "vagrant destroy 1a2b3c4d"

    $ vagrant destroy 5d8d809
        default: Are you sure you want to destroy the 'default' VM? [y/N] 

For more information, read about [getting started with Vagrant].

[VirtualBox]: https://www.virtualbox.org/
[Vagrant]: https://www.vagrantup.com/
[getting started with Vagrant]: https://www.vagrantup.com/intro/getting-started/index.html
[Composer]: https://getcomposer.org/download/
[Miniconda3]: https://docs.conda.io/en/latest/miniconda.html
