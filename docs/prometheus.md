# INSTALLATION PROMETHEUS HELM

### Clean up
```
helm uninstall -n prometheus my-prometheus 
helm uninstall -n grafana grafana 
helm repo remove prometheus-community
helm repo remove grafana 
```

### Storageclasses

storageclasses
```
cat storageclass.yml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
  annotations:
    storageclass.kubernetes.io/is-default-class: false
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

pv
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: prometheus
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /mnt/kube-data
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node01.local
```

### Installation
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm inspect values prometheus-community/prometheus > /tmp/prometheus-values.yaml
cp /tmp/prometheus-values.yaml /tmp/values.yaml

cat /tmp/values.yaml
---
prometheus-pushgateway:
  enabled: false
alertmanager:
  enabled: false
--- 
helm install my-prometheus prometheus-community/prometheus --version 22.6.7 --create-namespace --namespace prometheus -f /tmp/values.yaml
```

### Vérification
```
kubectl get all -n prometheus
export POD_NAME=$(kubectl get pods --namespace prometheus -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=my-prometheus" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace prometheus port-forward my-prometheus-server-79d77f658b-htgp7 9090

```