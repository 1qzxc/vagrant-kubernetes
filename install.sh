### to-do:
### need to add menu for components installation before runnign the vagrant up and stuff
### need bash script that would handle all the components like cri-o docker runc podman etc

# ask questions
# 0) prerequisites - win/lin/gpu-passthrough, kvm virtualbox, ram, cpu,
# 1) ask number of master nodes and slaves
# 2) ask loadbalancer for HA master nodes if master > 1
# 3) ask info about LAN -- subnet (192.168.1.0/24), set up ip pool for nodes
# 4) ask about docker image caches, registry, apt caches, proxy connections, gateway to internet
# 5) ask about volume storage class - nfs or external ceph or whatever
# 3) pick kubeadm kubespray or manual 
# 4) pick apps to be installed 
# 5) pick networking - metallb, nginx-ingress, istio
# 6) ask if this is only one cluster or service-mesh k8s x2
# 7) generate config.rb
# 8) run vagrant up master and wait until in is OK
# 9) run vagrant up for rest of the nodes
