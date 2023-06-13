#!/bin/bash

# ------------------------------------
# init cluster
# ------------------------------------
kubeadm init \
  --token yv9qp7.gt83s3w8kq4lfqww \
  --apiserver-advertise-address='192.168.10.11' \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket unix:///var/run/cri-dockerd.sock \
  --upload-certs \
  --control-plane-endpoint=cluser.local

# ------------------------------------
# Configure kubectl
# ------------------------------------
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# ------------------------------------
# Install flannel network
# ------------------------------------
cd /root/
wget https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f kube-flannel.yml

# ------------------------------------
# Kubectl completion
# ------------------------------------
apt-get install bash-completion </dev/null
source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
kubectl completion bash >/etc/bash_completion.d/kubectl
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc