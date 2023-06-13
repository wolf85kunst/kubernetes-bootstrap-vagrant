# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  (1..3).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "192.168.10.#{i + 10}"
      #node.vm.network "private_network", ip: "192.168.1.#{i + 10}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 1
        vb.name = "node-#{i}"
        vb.customize ["modifyvm", :id, "--ioapic", "on"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--ioapic", "on"]
        #vb.customize ["createhd", "--filename", "node-#{i}", "--size", "10240"]
      end

        node.vm.provision "shell", path: "scripts/setup.sh"
        node.vm.provision "shell", path: "scripts/common.sh"
     
      if i == 1
        node.vm.provision "shell", path: "scripts/master.sh"
      else
        node.vm.provision "shell", path: "scripts/worker.sh"
      end
    
    end
  end
end
