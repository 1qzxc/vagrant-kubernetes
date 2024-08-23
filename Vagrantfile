# -*- mode: ruby -*-
# vi: set ft=ruby :

require './config.rb'


IMAGE_NAME = "generic/ubuntu2004"
#IMAGE_NAME = "generic/ubuntu2204"
N = 6

Vagrant.configure("2") do |config|
    config.ssh.insert_key = 'false'
    config.vm.provider :libvirt do |libvirt|
        libvirt.memory = 16384
        libvirt.cpus = 8
        libvirt.storage :file, :size => '400G'
    end

    config.vm.define MASTERHOSTNAME do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "public_network", bridge: "vbr1s0", dev: "vbr1s0", type: "bridge", mode: "bridge", ip: MASTERIP
#        master.vm.network "public_network", bridge: "tun0", dev: "tun0", type: "bridge", mode: "bridge", ip: MASTERIP
        master.vm.hostname = MASTERHOSTNAME
        master.vm.provision "shell" do |s|
            s.path = "kubernetes-setup/master.sh"
            s.args = [MASTERIP, DOCKERCACHE, APTCACHE, CIDR, KUBEVERSION, MASTERHOSTNAME, K8SSHORT]
        end
    end
end

Vagrant.configure("2") do |config|
    config.ssh.insert_key = 'false'
    config.vm.provider :libvirt do |v|
        v.memory = 16384
        v.cpus = 8
        v.storage :file, :size => '200G'
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node_ip = NODEIP[i-1]
            node.vm.network "public_network", bridge: "vbr1s0", dev: "vbr1s0", type: "bridge", mode: "bridge", ip: "#{node_ip}"
            node.vm.hostname = "node-#{i}.home"
            node.vm.provision "shell" do |s|
                s.path = "kubernetes-setup/node.sh"
                s.args = [MASTERIP, NODEIP[i-1], DOCKERCACHE, APTCACHE, KUBEVERSION, MASTERHOSTNAME, K8SSHORT]
            end
        end
    end
    config.vm.define "node-7" do |node|
        node.vm.box = IMAGE_NAME
        node_ip = NODEIP[6]
        node.vm.network "public_network", bridge: "vbr1s0", dev: "vbr1s0", type: "bridge", mode: "bridge", ip: "#{node_ip}"
        node.vm.hostname = "node-7.home"
        node.vm.provider :libvirt do |v|
            v.memory = 16384
            v.cpus = 8
            v.storage :file, :size => '100G'
            v.pci :bus => '0x03', :slot => '0x00', :function => '0x0'
            #v.pci :bus => '0x07', :slot => '0x00', :function => '0x1'
        end
        node.vm.provision "shell" do |s|
            s.path = "kubernetes-setup/node-gpu.sh"
            s.args = [MASTERIP, NODEIP[1], DOCKERCACHE, APTCACHE, KUBEVERSION, MASTERHOSTNAME, K8SSHORT]
        end
    end
    
        config.vm.define "node-8" do |node|
        node.vm.box = IMAGE_NAME
        node_ip = NODEIP[6]
        node.vm.network "public_network", bridge: "vbr1s0", dev: "vbr1s0", type: "bridge", mode: "bridge", ip: "#{node_ip}"
        node.vm.hostname = "node-8.home"
        node.vm.provider :libvirt do |v|
            v.memory = 16384
            v.cpus = 8
            v.storage :file, :size => '100G'
            v.pci :bus => '0x02', :slot => '0x00', :function => '0x0'
        end
        node.vm.provision "shell" do |s|
            s.path = "kubernetes-setup/node-gpu.sh"
            s.args = [MASTERIP, NODEIP[1], DOCKERCACHE, APTCACHE, KUBEVERSION, MASTERHOSTNAME, K8SSHORT]
        end
    end


end
