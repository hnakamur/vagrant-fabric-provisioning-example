# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos6.4"
  config.vm.network :private_network, ip: "192.168.33.16"

  config.vm.provision :shell, :path => "setup_fabric.sh"
  config.vm.synced_folder "fabfile", "/home/vagrant/fabfile"
  config.vm.provision :shell, :inline =>
    "export PATH=/usr/local/python-2.7.5/bin:$PATH; fab"
end
