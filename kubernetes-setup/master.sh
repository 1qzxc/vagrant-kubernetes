#!/bin/bash

set -e

MASTERIP=$1
DOCKERCACHE=$2
APTCACHE=$3
CIDR=$4
KUBEVERSION=$5
MASTERHOSTNAME=$6
K8SSHORT=$7

export MASTERHOSTNAME=$6
export DOCKERCACHE=$2

# delete vagrant auto-configured default gateway
# to-do: add if default route == 192.168.121.1
#sudo ip route del default via 192.168.121.1
sudo ip route del default via 192.168.122.1
# to-do: add if default route == 10.0.2.2
#sudo ip route del default via 10.0.2.2

# add real LAN gateway as default
sudo ip route add default via 192.168.1.1
sudo sed -e s/4.2.2.2,\ //g -i /etc/netplan/01-netcfg.yaml
sudo sed -e s/4.2.2.1,\ //g -i /etc/netplan/01-netcfg.yaml
sudo sed -e s/4.2.2.1\ //g -i /etc/systemd/resolved.conf
sudo sed -e s/4.2.2.2\ //g -i /etc/systemd/resolved.conf


### add default route to netplan yaml config
#
sudo cat <<EOF >>/etc/netplan/01-netcfg.yaml
    eth1:
      routes:
      - to: default
        via: 192.168.1.1
EOF

sudo sed '/\ \ \ \ eth0:/a \ \ \ \ \ \ dhcp4-overrides:\n\ \ \ \ \ \ \ \ use-routes: false' /etc/netplan/01-netcfg.yaml >> temp.yaml
sudo cp -f temp.yaml /etc/netplan/01-netcfg.yaml
sudo netplan apply
sudo systemctl restart systemd-networkd
sudo systemctl restart systemd-resolved

# to-do: configure netplan for persistance
#sudo echo "UseRoutes=false" >> /run/systemd/network/10-netplan-eth0.network

# to-do: substitute with variables from config.rb, add for each slave loop
sudo echo "$MASTERIP $MASTERHOSTNAME" >> /etc/hosts
#sudo echo "192.168.1.147 docker.io" >> /etc/hosts

sudo apt-get update -y

# install dns reloader to apply /etc/hosts immediately
sudo apt-get install nscd -y
sudo service nscd restart


# use local LAN apt cache server to save traffic
# if APTCACHE != '' :
if [ -z "$APTCACHE" ]
then
    echo "APTCACHE var is unset, using remote ubuntu mirrors"
else 
    sudo echo 'Acquire::HTTP::Proxy "http://'$APTCACHE'";' >> /etc/apt/apt.conf.d/01proxy
    sudo echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy
fi

sudo apt update -y




# install container runtime
git clone -b feature/fedora39-256g http://192.168.1.147:3000/1q2w3e/vagrant-kubernetes.git
sudo chmod +x /home/vagrant/vagrant-kubernetes/kubernetes-setup/files/ct-runtime/docker.sh
sudo /home/vagrant/vagrant-kubernetes/kubernetes-setup/files/ct-runtime/docker.sh $MASTERHOSTNAME $DOCKERCACHE

# install k8s
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$K8SSHORT/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$K8SSHORT/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update -y
sudo apt-get install -qy kubelet kubectl kubeadm
sudo apt-mark hold kubelet kubeadm kubectl
kubectl version --client && kubeadm version
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
# Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter
# Add some settings to sysctl
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system

sudo lsmod | grep br_netfilter

sudo systemctl enable kubelet

sudo kubeadm config images pull
 
sudo echo "KUBELET_EXTRA_ARGS=--node-ip=$MASTERIP" >> /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
#/etc/systemd/system/kubelet.service.d/10-kubeadm.conf
#/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
#/etc/systemd/system/kubelet.service.d/

sudo kubeadm init --apiserver-advertise-address="$MASTERIP" --apiserver-cert-extra-sans="$MASTERIP"  --node-name "$MASTERHOSTNAME" --pod-network-cidr="$CIDR" --control-plane-endpoint="$MASTERHOSTNAME" 

sudo kubeadm token create --print-join-command >> /tmp/join-command.sh


sudo mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
sudo chown $(id -u):$(id -g) /root/.kube/config


kubectl cluster-info

sudo chmod +x /home/vagrant/vagrant-kubernetes/kubernetes-setup/files/persistance/local.sh
sudo /home/vagrant/vagrant-kubernetes/kubernetes-setup/files/persistance/local.sh


#sudo kubectl create -f vagrant-kubernetes/kubernetes-setup/files/cni/flannel.yaml


sudo kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml



# calico installation
#
#sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
## use custom cidr in custom-resources
#sudo tee custom-resources.yaml<<EOF
## This section includes base Calico installation configuration.
## For more information, see: https://docs.tigera.io/calico/latest/reference/installation/api#operator.tigera.io/v1.Installation
#apiVersion: operator.tigera.io/v1
#kind: Installation
#metadata:
#  name: default
#spec:
#  # Configures Calico networking.
#  calicoNetwork:
#    ipPools:
#    - name: default-ipv4-ippool
#      blockSize: 26
#      cidr: $CIDR
#      encapsulation: VXLANCrossSubnet
#      natOutgoing: Enabled
#      nodeSelector: all()
#
#---
#
## This section configures the Calico API server.
## For more information, see: https://docs.tigera.io/calico/latest/reference/installation/api#operator.tigera.io/v1.APIServer
#apiVersion: operator.tigera.io/v1
#kind: APIServer
#metadata:
#  name: default
#spec: {}
#EOF
#
#sudo kubectl create -f custom-resources.yaml







#watch kubectl get pods -n calico-system

# install helm
sudo curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# use nfs default volume storage
sudo apt-get install nfs-kernel-server nfs-common portmap -y
sudo systemctl start nfs-server
sudo mkdir -p /srv/nfs/mydata 
sudo chmod -R 777 /srv/nfs/ # for simple use but not advised
sudo chown -R nobody:nogroup /srv/nfs/
sudo echo "/srv/nfs/mydata  *(rw,sync,no_subtree_check,no_root_squash,insecure)" >> /etc/exports
sudo exportfs -rv
sudo mount -t nfs $MASTERIP:/srv/nfs/mydata /mnt
sudo helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
sudo helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=$MASTERIP \
    --set nfs.path=/srv/nfs/mydata

# change default storageclass
sudo kubectl patch storageclass local-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
sudo kubectl patch storageclass nfs-client -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

sudo chmod +x vagrant-kubernetes/kubernetes-setup/files/loadbalancer/metallb.sh
sudo ./vagrant-kubernetes/kubernetes-setup/files/loadbalancer/metallb.sh 


sudo helm repo add nginx-stable https://helm.nginx.com/stable
sudo helm repo update
sudo helm install nginx-ingress nginx-stable/nginx-ingress






# to do: add metrics server installation 



# to do: 


# add engine stack: 
# add kubeadm           ( + )
# add kubespray         ( - )
# add k8s the hard way  ( - )
# add k8s PRD setup     ( - )
# add k3s               ( - )
# add k0s               ( - )
# add kind              ( - )
# add containerd        ( test )
# add cri-o             ( test )
# add podman            ( - )
# add runc              ( - )
# add OpenShift         ( - )


# add infra stack:
# add infra configuration to config.rb        ( + )
# run private docker registry                 ( + )
# setup https on docker registry              ( - )
# optional: configure and run gitea           ( + )
# optional: pull repos and push them to gitea ( - )
# deploy prometheus                           ( + )
# deploy grafana                              ( + )
# configure monitoring                        ( - )
# add logging                                 ( - )
# add alerting                                ( - )
# add Active Directory                        ( - )
# add RBAC policies and stuff                 ( - )
# add WSO2                                    ( - )
# add gravitee                                ( - )
# add API Umbrella                            ( - )
# add APIman                                  ( - )
# add Kong                                    ( - )
# add Tyk                                     ( - )
# add Swagger                                 ( - )
# add Apigility                               ( - )
# add cert-manager with wildcard cert         ( - )
# add subdomain configuration xxx.domain.com for apps  ( - )
# add loki                                    ( - )
# add graphite                                ( - )
# add thanos                                  ( - )
# add envoy                                   ( - )
# add Traefik                                 ( - )
# add Nginx                                   ( - )
# add HAproxy                                 ( - )
# add Kong                                    ( - )
# add istio (+ HA)                            ( - )
# add master node HA                          ( - )
# add kui                                     ( - )
# add kuberlogic                              ( - )
# add telepresence                            ( - )
# add Fission                                 ( + )
# add ArgoCD                                  ( + )
# add jenkins with values                     ( - )
# configure iac pipelines                     ( - )


# deploy app stack                            ( - )
# add vault                                   ( - )
# add keystore                                ( - )
# add helmchart museum                        ( - )
# add SonarQube                               ( - )
# add Sentry                                  ( - )
# add metallb                                 ( + )
# add LinkerD                                 ( - )
# add metrics-server                          ( - )
# add Dashboard                               ( - )
# add keycloak                                ( - )


# add storage stack:
# add Ceph                                    ( + )
# add NFS                                     ( + )
# add MiniO                                   ( - )
# add OpenEBS                                 ( - )
# add Rook                                    ( - )
# add GlusterFS                               ( - )
# add Portworx                                ( - )
# add longHorn                                ( - )


# add app stack
# pull app source and helm chart for dummy app from remote
# build and push to private registry
# deploy to kubernetes app along with resources needed for app
# add OIDC                                    ( - )
# add oauth2                                  ( - )
# add JWT                                     ( - )
# add kafka                                   ( - )
# add redis                                   ( - )
# add rabbitmq                                ( - )
# add memcached                               ( - )
# add consul                                  ( - )
# add mlops                                   ( - )
# add kubeflow                                ( - )
# add vitess                                  ( - )
# add patroni                                 ( - )
# add percona                                 ( - )
# add web3                                    ( - )
# add tritonserver



