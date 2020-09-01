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
    
end
