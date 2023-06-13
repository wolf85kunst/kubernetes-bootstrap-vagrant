# kubernetes-bootstrap-vagrant
Deploy kubernetes cluster (3 nodes) with vagrant

### Requierements
Please feed your private key in private.key file : TAG = __MY_PRIVATE_KEY__<br />
Replace your pubic key : TAG = __MY_PUBLIC_KEY__<br />

### Run vagrant
```
hugo@sandbox:~/Git/kubernetes-bootstrap-vagrant$ tree 
.
├── private.key
├── README.md
├── scripts
│   ├── common.sh
│   ├── master.sh
│   ├── setup.sh
│   └── worker.sh
└── Vagrantfile

1 directory, 7 files
```

```
$ time vagrant up
[...]
real	16m0,050s
user	0m14,373s
sys	0m6,879s
```

### Check Vagrant status
```
$ vagrant global-status |grep running
502e2b7  node-1 virtualbox running /home/hugo/Work/Vagrant/build_k8s   
7d0d913  node-2 virtualbox running /home/hugo/Work/Vagrant/build_k8s   
88a5a18  node-3 virtualbox running /home/hugo/Work/Vagrant/build_k8s
```

### Set your local environnement to manager local K8S cluster
```
scp -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no root@192.168.10.11:/etc/kubernetes/admin.conf $HOME/.kube/sandbox
sed -i "s@server: https://.*@server: https://192.168.10.11:6443@" $HOME/.kube/sandbox
echo "alias sandbox='export KUBECONFIG=/$HOME/.kube/sandbox && kubectl config get-contexts'" >> ~/.bashrc
source ~/.bashrc
sandbox
kubectl config rename-context kubernetes-admin@kubernetes sandbox
kubectl config set-context --current --namespace=default
kubectl config get-contexts
kubectl cluster-info
kubectl get nodes -o wide
kubectl get all --all-namespaces
```
