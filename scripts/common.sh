#!/bin/bash

apt-get update </dev/null
apt-get -y upgrade </dev/null
echo

# ------------------------------------
# Install repos
# ------------------------------------
sudo apt install curl apt-transport-https -y </dev/null
curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/k8s.gpg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# ------------------------------------
# Install tools
# ------------------------------------
sudo apt update </dev/null
sudo apt install wget curl vim git kubelet kubeadm kubectl -y </dev/null
sudo apt-mark hold kubelet kubeadm kubectl </dev/null

# ------------------------------------
# Network settings
# ------------------------------------
swapoff -a 
modprobe overlay
modprobe br_netfilter
tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# ------------------------------------
# Docker Runtime
# ------------------------------------
sudo apt update </dev/null
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates </dev/null
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" </dev/null
sudo apt update </dev/null
sudo apt install -y containerd.io docker-ce docker-ce-cli </dev/null

# Create required directories
sudo mkdir -p /etc/systemd/system/docker.service.d

# Create daemon json config file
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Start and enable Services
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker

# Configure persistent loading of modules
sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

# Ensure you load modules
sudo modprobe overlay
sudo modprobe br_netfilter

# (cri-dockerd)
# ------------------------------------
lsmod | grep br_netfilter

sudo apt update </dev/null
sudo apt install git wget curl </dev/null
VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
echo $VER
wget https://github.com/Mirantis/cri-dockerd/releases/download/v${VER}/cri-dockerd-${VER}.amd64.tgz
tar xvf cri-dockerd-${VER}.amd64.tgz
sudo mv cri-dockerd/cri-dockerd /usr/local/bin/
cri-dockerd --version
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
sudo systemctl status cri-docker.socket

# ------------------------------------
# Host file
# ------------------------------------
cat <<EOF >>/etc/hosts
192.168.10.11 node-1 node-1.cluser.local cluser.local
192.168.10.12 node-2 node-2.cluser.local
192.168.10.13 node-3 node-3.cluser.local
EOF
echo

# ------------------------------------
# Control Plane
# ------------------------------------
sudo kubeadm config images pull --cri-socket unix:///var/run/cri-dockerd.sock