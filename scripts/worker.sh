#!/bin/bash

# Join k8s cluster without installing control-plane
kubeadm join cluser.local:6443 --token yv9qp7.gt83s3w8kq4lfqww \
	--discovery-token-unsafe-skip-ca-verification \
	--cri-socket unix:///var/run/cri-dockerd.sock

# Join k8s cluster by installing control-plane 
# kubeadm join cluser.local:6443 --token yv9qp7.gt83s3w8kq4lfqww \
# 	--discovery-token-ca-cert-hash sha256:d2b1ce5a07a7295315217eefd2fd8f07871ea85417b1d9f8f6eaf3f283dd6841 \
# 	--control-plane --certificate-key 99cafd9c4d0379112d0e1d74cf8ba3fab6bdb00f7031d788021fc3e110a8fecd \
#   --cri-socket unix:///var/run/cri-dockerd.sock