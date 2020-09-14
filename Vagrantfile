# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_VER="2"

Vagrant.configure(VAGRANTFILE_VER) do |config|
  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = 'UTC'
  end
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
  end

  config.vm.define :api do | subconfig |
    subconfig.vm.box = "geerlingguy/debian10"
    subconfig.vm.box_version = "1.0.9"
    subconfig.vm.box_check_update = false
    
    subconfig.vm.hostname = "apis.me"

    # private network so that nginx can talk to node apps
    subconfig.vm.network :private_network, ip: "192.168.64.10"

    # api (NODEJS/Python) go here and are linked over to the box there.
    subconfig.vm.synced_folder "api1_project/", "/opt/api1/", create: true
    subconfig.vm.synced_folder "api2_project/", "/opt/api2/", create: true

    # api (NODEJS currently) build scripts
    subconfig.vm.provision :shell, path: "./build_scripts/node_from_scratch.sh"

    subconfig.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "1024"
      vb.cpus = "2"
    end
  end

  config.vm.define :web do | subconfig |
    subconfig.vm.box = "geerlingguy/debian10"
    subconfig.vm.box_version = "1.0.9"
    subconfig.vm.box_check_update = false

    subconfig.vm.hostname = "frontdoor.me"

    # direct access to API 1 and 2 from outside the debian box
    subconfig.vm.network "forwarded_port", guest: 80, host: 8080, id: "nginx"

    # private network so that nginx can talk to node apps
    subconfig.vm.network :private_network, ip: "192.168.64.20"

    # api (NODEJS currently) build scripts
    subconfig.vm.provision :shell, path: "./build_scripts/build_tools.sh"
    subconfig.vm.provision :shell, path: "./build_scripts/nginx_from_scratch.sh"

    subconfig.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "1024"
      vb.cpus = "1"
    end
  end

  config.vm.define :database do |subconfig|
    subconfig.vm.box = "geerlingguy/debian10"
    subconfig.vm.box_version = "1.0.9"
    subconfig.vm.box_check_update = false
    subconfig.vm.hostname = "db.local"
    subconfig.vm.network :private_network, ip: "192.168.64.30"
    subconfig.vm.provision :shell, path: "./build_scripts/mongo-install.sh"

    subconfig.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "1024"
      vb.cpus = "1"
    end
  end
    
end
