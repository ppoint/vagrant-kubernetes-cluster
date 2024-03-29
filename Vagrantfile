# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
  config.vm.synced_folder ".", "/vagrant_data"

  boxes = [
    { :name => "master",  :ip => "172.16.8.10", :cpus => 1, :memory => 2048 },
    { :name => "node-01", :ip => "172.16.8.11", :cpus => 1, :memory => 2048 },
    { :name => "node-02", :ip => "172.16.8.12", :cpus => 1, :memory => 2048 },
  ]

  boxes.each do |opts|
    config.vm.define opts[:name] do |box|
      box.vm.hostname = opts[:name]
      box.vm.network :private_network, ip: opts[:ip]
 
      box.vm.provider "virtualbox" do |vb|
        vb.cpus = opts[:cpus]
        vb.memory = opts[:memory]
      end
      box.vm.provider "libvirt" do |lv|
        lv.cpus = opts[:cpus]
        lv.memory = opts[:memory]
      end

      box.vm.provision "shell", path:"./install-kubernetes-dependencies.sh"
      if box.vm.hostname == "master" then 
        box.vm.provision "shell", path:"./configure-master-node.sh"
        end
      if box.vm.hostname.match(/^node/) then
        box.vm.provision "shell", path:"./configure-worker-nodes.sh"
      end

    end
  end
end
