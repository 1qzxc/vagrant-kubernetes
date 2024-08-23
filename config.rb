# -*- mode: ruby -*-
# vi: set ft=ruby :
#
### GIT CONFIG PARAMS ###
# for code development
GITNAME=''
GITEMAIL=''
GITEDITOR='vim'
GITVERSION='2.23.0'
GITHUBUSER=''


### network topology
### LAN network (assume 192.168.1.0/24)
### master node lan ip address:
MASTERIP='192.168.1.170'
### slave nodes lan ip address pool:
NODEIP = ['192.168.1.171', '192.168.1.172', '192.168.1.173', '192.168.1.174', '192.168.1.175', '192.168.1.176', '192.168.1.177', '192.168.1.178' ]
# kubeadm CIDR for pod network calico/flannell
CIDR = '10.244.0.0/16'
#CIDR = '10.48.0.0/21' -- faulty ? used for calico
# hostname for master node
MASTERHOSTNAME = 'k8smaster.home'
# docker images cache server that saves ghcr k8s images and stuff so not to spam remote registries
DOCKERCACHE = '192.168.1.147'
# same for apt
APTCACHE = '192.168.1.147:3142'
# desired k8s version
KUBEVERSION='1.30.0-00'
K8SSHORT='1.30'



