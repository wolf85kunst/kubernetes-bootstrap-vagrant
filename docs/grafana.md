# GRAFANA INSTALLATION HELM

### Storage
```
# StorageClasses
cat << EOF > /tmp/storageClasses.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage-2
  annotations:
    storageclass.kubernetes.io/is-default-class: false
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF
kubectl apply -f /tmp/storageClasses.yaml

# PersistentVolume
cat << EOF > /tmp/grafana-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: grafana
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /mnt/grafana
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node01.develop.matooma.com
EOF
kubectl apply -f /tmp/grafana-pv.yaml
```

### Installation
```
helm repo add grafana https://grafana.github.io/helm-charts
helm inspect values grafana/grafana > /tmp/grafana_values.yaml

cat << EOF > /tmp/grafana_values_custom.yaml
persistence:
  type: pvc
  enabled: true
EOF

helm install grafana grafana/grafana --create-namespace --namespace grafana --values /tmp/grafana_values_custom.yaml 

kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
export POD_NAME=$(kubectl get pods --namespace grafana -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace grafana port-forward $POD_NAME 3000
```
