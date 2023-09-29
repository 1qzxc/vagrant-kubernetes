# -*- mode: ruby -*-
# vi: set ft=ruby :

require './config.rb'


IMAGE_NAME = "generic/ubuntu2204"

Vagrant.configure("2") do |config|
    config.ssh.insert_key = 'false'

    config.vm.define MASTERHOSTNAME do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "public_network", bridge: "br0", dev: "br0", type: "bridge", mode: "bridge", ip: MASTERIP
        master.vm.hostname = MASTERHOSTNAME
        master.vm.provider :libvirt do |libvirt|
            libvirt.memory = 8192
            libvirt.cpus = 2
            libvirt.storage :file, :size => '50G'
        end
        master.vm.provision "shell" do |s|
            s.path = "kubernetes-setup/master.sh"
            s.args = [MASTERIP, DOCKERCACHE, APTCACHE, CIDR, KUBEVERSION, MASTERHOSTNAME]
        end
    end

    config.vm.define "node-1" do |node|
        node.vm.box = IMAGE_NAME
        node_ip = NODEIP[1]
        node.vm.network "public_network", bridge: "br0", dev: "br0", type: "bridge", mode: "bridge", ip: "#{node_ip}"
        node.vm.hostname = "node-1.home"
        node.vm.provider :libvirt do |v|
           v.memory = 12288
           v.cpus = 2
           v.storage :file, :size => '50G'
        end
        node.vm.provision "shell" do |s|
            s.path = "kubernetes-setup/node.sh"
            s.args = [MASTERIP, NODEIP[1], DOCKERCACHE, APTCACHE, KUBEVERSION, MASTERHOSTNAME]
        end
    end

    config.vm.define "node-2" do |node|
        node.vm.box = IMAGE_NAME
        node_ip = NODEIP[2]
        node.vm.network "public_network", bridge: "br0", dev: "br0", type: "bridge", mode: "bridge", ip: "#{node_ip}"
        node.vm.hostname = "node-2.home"
        node.vm.provider :libvirt do |v|
            v.memory = 8192
            v.cpus = 2
            v.storage :file, :size => '50G'
            v.pci :bus => '0x07', :slot => '0x00', :function => '0x0'
            v.pci :bus => '0x07', :slot => '0x00', :function => '0x1'
        end
        node.vm.provision "shell" do |s|
            s.path = "kubernetes-setup/node.sh"
            s.args = [MASTERIP, NODEIP[2], DOCKERCACHE, APTCACHE, KUBEVERSION, MASTERHOSTNAME]
        end
    end
end

