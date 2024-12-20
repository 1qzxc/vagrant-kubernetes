# vagrant-kubernetes
this is to spin up three or more virtual machines and install kubernetes inside


## system requirements
This thing needs 8gig 2cpu cores per machine totalling in 24gig 6bpu for 3 vms

## prereqs
- Linux (Tested on Centos7/8 Fedora 38/39/40)
- Vagrant
- KVM/Libvirt
- br0 bridged interface for KVM vms
- Vagrant libvirt plugin
- Nvidia GPUs (optional)

## usage
1) Add info to config.rb

2) Up the master, it will generate the join command for nodes (slaves)

```
vagrant up k8smaster.home
```

3) Up rest of the nodes
```
vagrant up
```

## Problems

And the problems there are indeed... 

1) (fixed) vagrant adds default NIC that it uses to configure and provision VMS. It configures default route to that NIC which is NAT. K8s can't use that so the workaround is to: 
- Add second NIC and assign static IP address to that and add all the vms hostnames and addresses to /etc/hosts
- reconfigure default routes, drop gateway added by vagrant through virtualbox/libvirt and set our LAN default gateway
- (to-do) use netplan to make this permanent so the cluster survives reboot and avoid manually reconfiguring default gateways

2) Virtualbox/libvirt assign different CIDR blocks to default gateways so you have pay attention to that when deleting gw

3) At the moment hashicorp had blocked rus ip addresses so you can't download and install vagrant if you don't have VPN. You might wanna git clone and build vagrant and vagrant-libvirt plugin manually on a clean system (that's what I did)

4) (to-do) firewalld blocks libvirt VM traffic if you build vagrant manually. W/a = systemctl stop firewalld && systemct disable firewalld

5) vagrant boxes aren't downloadable from hashicorp due to ip ban

6) (to-do) Vagrantfile needs adjustment for libvirt/virtualbox vm config atm. Need to add provider detection.

7) when vagrant built manually from dev branch, provisioning starts before the NIC is configured, hence gotta first create vms with --no-provision option and later vagrant up --provision
