# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "off"]
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    vb.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
    vb.customize ["modifyvm", :id, "--nicpromisc5", "allow-all"]
    vb.cpus = 1
  end
  config.vm.define "router-1" do |router1|
    router1.vm.box = "ubuntu/bionic64"
    router1.vm.hostname = "router-1"
    router1.vm.network "private_network", virtualbox__intnet: "router1-switch", auto_config: false
    router1.vm.network "private_network", virtualbox__intnet: "router1-router2", auto_config: false
    router1.vm.provision "shell", path: "router-1.sh"
    router1.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
  config.vm.define "router-2" do |router2|
    router2.vm.box = "ubuntu/bionic64"
    router2.vm.hostname = "router-2"
    router2.vm.network "private_network", virtualbox__intnet: "router2-hostc", auto_config: false
    router2.vm.network "private_network", virtualbox__intnet: "router2-router1", auto_config: false
    router2.vm.provision "shell", path: "router-2.sh"
    router2.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
  config.vm.define "switch" do |switch|
    switch.vm.box = "ubuntu/bionic64"
    switch.vm.hostname = "switch"
    switch.vm.network "private_network", virtualbox__intnet: "switch-router1", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "switch-hosta", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "switch-hostb", auto_config: false
    switch.vm.provision "shell", path: "switch.sh"
    switch.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
  config.vm.define "host-a" do |hosta|
    hosta.vm.box = "ubuntu/bionic64"
    hosta.vm.hostname = "host-a"
    hosta.vm.network "private_network", virtualbox__intnet: "hosta-switch", auto_config: false
    hosta.vm.provision "shell", path: "host-1a.sh"
    hosta.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
  config.vm.define "host-b" do |hostb|
    hostb.vm.box = "ubuntu/bionic64"
    hostb.vm.hostname = "host-b"
    hostb.vm.network "private_network", virtualbox__intnet: "hostb-switch", auto_config: false
    hostb.vm.provision "shell", path: "host-1b.sh"
    hostb.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
  config.vm.define "host-c" do |hostc|
    hostc.vm.box = "ubuntu/bionic64"
    hostc.vm.hostname = "host-c"
    hostc.vm.network "private_network", virtualbox__intnet: "hostc-router2", auto_config: false
    hostc.vm.provision "shell", path: "host-2c.sh"
    hostc.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
end
