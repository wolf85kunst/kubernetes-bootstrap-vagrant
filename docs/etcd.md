# etcdctl

### Installation etcd

> https://etcd.io/docs/v3.4/install/
> https://github.com/etcd-io/etcd/releases/

```
ETCD_VER=v3.4.26

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

/tmp/etcd-download-test/etcd --version
/tmp/etcd-download-test/etcdctl version

mv /tmp/etcd-download-test/etcdctl /usr/local/bin/./

etcdctl version
```


### Commandes etcd

```
# LIST ETCD MEMBER :
# ETCDCTL_API=3 etcdctl --endpoints 10.132.0.29:2379 --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key --cacert=/etc/kubernetes/pki/etcd/ca.crt member list
7e69cb1d35d008b1, started, clus6-0, https://10.132.0.29:2380, https://10.132.0.29:2379, false

# LIST ETCD KEYS
ETCDCTL_API=3 etcdctl --endpoints 10.132.0.29:2379   --cert=/etc/kubernetes/pki/etcd/server.crt   --key=/etc/kubernetes/pki/etcd/server.key   --cacert=/etc/kubernetes/pki/etcd/ca.crt get "" --prefix --keys-only | sed '/^$/d' | nl

# BACKUP ETCD
# ETCDCTL_API=3 etcdctl --endpoints 10.132.0.29:2379   --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key --cacert=/etc/kubernetes/pki/etcd/ca.crt snapshot save /var/backups/etcd_k8s_$(date +%Y%m%d%H%M).bkp
{"level":"info","ts":1688470015.2632365,"caller":"snapshot/v3_snapshot.go:119","msg":"created temporary db file","path":"/var/backups/etcd_k8s_202307041126.bkp.part"}
{"level":"info","ts":"2023-07-04T11:26:55.271252Z","caller":"clientv3/maintenance.go:200","msg":"opened snapshot stream; downloading"}
{"level":"info","ts":1688470015.2713597,"caller":"snapshot/v3_snapshot.go:127","msg":"fetching snapshot","endpoint":"10.132.0.29:2379"}
{"level":"info","ts":"2023-07-04T11:26:55.415369Z","caller":"clientv3/maintenance.go:208","msg":"completed snapshot read; closing"}
{"level":"info","ts":1688470015.4400535,"caller":"snapshot/v3_snapshot.go:142","msg":"fetched snapshot","endpoint":"10.132.0.29:2379","size":"6.2 MB","took":0.176691887}
{"level":"info","ts":1688470015.440371,"caller":"snapshot/v3_snapshot.go:152","msg":"saved","path":"/var/backups/etcd_k8s_202307041126.bkp"}
Snapshot saved at /var/backups/etcd_k8s_202307041126.bkp

# RESTORE ETCD
ETCDCTL_API=3 etcdctl --endpoints 10.132.0.29:2379 --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key --cacert=/etc/kubernetes/pki/etcd/ca.crt snapshot restore /var/backups/etcd_k8s_202307041126.bkp
```