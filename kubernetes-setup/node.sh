#!/bin/bash

set -e

MASTERIP=$1
NODEIP=$2
DOCKERCACHE=$3
APTCACHE=$4
KUBEVERSION=$5
MASTERHOSTNAME=$6
K8SSHORT=$7
#run this dude with sudo

#sudo ip route del default via 192.168.121.1
#sudo ip route del default via 10.0.2.2
sudo ip route del default via 192.168.122.1
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
#ignore vagrant default gw
sudo sed '/\ \ \ \ eth0:/a \ \ \ \ \ \ dhcp4-overrides:\n\ \ \ \ \ \ \ \ use-routes: false' /etc/netplan/01-netcfg.yaml >> temp.yaml
sudo cp -f temp.yaml /etc/netplan/01-netcfg.yaml
sudo netplan apply
sudo systemctl restart systemd-networkd
sudo systemctl restart systemd-resolved


#sudo echo "UseRoutes=false" >> /run/systemd/network/10-netplan-eth0.network
sudo echo "$MASTERIP $MASTERHOSTNAME" >> /etc/hosts
sudo echo " Beginning the circus "



#sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common containerd.io docker-ce docker-cli
#sudo usermod -a -G docker vagrant
#sudo sed -i '/swap/d' /etc/fstab
#sudo swapoff -a 
#wget -qO - https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
#
##sudo add-apt-repository https://apt.kubernetes.io/ <??> deb  kubernetes-xenial main kubernetes.list
#sudo apt-get install -y kubelet kubeadm kubectl sshpass
#sudo echo "KUBELET_EXTRA_ARGS=--node-ip=$NODEIP" >> /usr/bin/kubelet
#
#sudo systemctl reload kubelet
#
##scp? scp root@k8s-master
#sshpass -p 'vagrant' scp vagrant@k8s-master:/tmp/join-command /tmp/join-command
#sudo chmod +x /tmp/join-command.sh && sudo /tmp/join-command.sh     
#

if [ -z "$APTCACHE" ]
then
    echo "APTCACHE var is unset, using remote ubuntu mirrors"
else 
    sudo echo 'Acquire::HTTP::Proxy "http://'$APTCACHE'";' >> /etc/apt/apt.conf.d/01proxy
    sudo echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy
fi


# install container runtime
git clone -b feature/fedora39-256g http://192.168.1.147:3000/1q2w3e/vagrant-kubernetes.git
sudo chmod +x /home/vagrant/vagrant-kubernetes/kubernetes-setup/files/ct-runtime/docker.sh
sudo /home/vagrant/vagrant-kubernetes/kubernetes-setup/files/ct-runtime/docker.sh $MASTERHOSTNAME $DOCKERCACHE
#
# fix containerd for newer k8s versions >=1.24
#sudo apt -y install vim git curl wget ca-certificates curl gnupg
#sudo install -m 0755 -d /etc/apt/keyrings
#
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
#sudo chmod a+r /etc/apt/keyrings/docker.gpg
#echo \
#  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt-get update -y
#sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
#sudo rm -f /etc/containerd/config.toml
#sudo systemctl restart containerd
# --- end fix

sudo apt -y install curl apt-transport-https sshpass
curl -k -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

#outdated
#echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
#echo "deb https://apt.kubernetes.io/ kubernetes-focal main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


#new
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
echo "running curl $K8SSHORT"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$K8SSHORT/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "running echo $K8SSHORT"
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$K8SSHORT/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list


sudo apt update
#sudo apt-get install -qy kubelet=$KUBEVERSION kubectl=$KUBEVERSION kubeadm=$KUBEVERSION
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


# fix for >=1.24

sudo lsmod | grep br_netfilter

#sudo systemctl enable kubelet

#sudo kubeadm config images pull
sudo apt-get install nfs-common -y
ssh-keygen -t rsa -N "" -f id_rsa
sudo sshpass -p 'vagrant' ssh-copy-id -i id_rsa -oStrictHostKeyChecking=no vagrant@$MASTERHOSTNAME
sudo scp -i id_rsa vagrant@$MASTERHOSTNAME:/tmp/join-command.sh /tmp/join-command.sh
sudo chmod +x /tmp/join-command.sh && sudo /tmp/join-command.sh 
mkdir -p /home/vagrant/pv1
sudo chmod 777 /home/vagrant/pv1




#export DEBIAN_FRONTEND=noninteractive
#sudo apt install nvidia-utils-535-server -y
#sudo apt install nvidia-headless-535-server -y
#sudo apt install libnvidia-encode-535-server  -y
#sudo apt install nvidia-cuda-toolkit -y
#sudo nvcc -V
#sudo apt install python3-pip -y
#pip3 install torch torchvision torchaudio


#sudo curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg   && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |     sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |     sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list   &&     sudo apt-get update -y
#sudo apt-get install -y nvidia-container-toolkit
#sudo apt install nvidia-container-runtime -y
#sudo nvidia-ctk runtime configure --runtime=docker
#sudo systemctl restart docker


apt install curl apt-transport-https -y
curl https://mirror.croit.io/keys/release.gpg > /usr/share/keyrings/croit-signing-key.gpg
echo 'deb [signed-by=/usr/share/keyrings/croit-signing-key.gpg] https://mirror.croit.io/debian-mimic/ stretch main' > /etc/apt/sources.list.d/croit-ceph.list
sudo apt update -y
sudo apt install ceph-common -y

sudo echo " it has been done. "
sudo reboot


