# Installation Prometheus operator

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm show values prometheus-community/kube-prometheus-stack > /tmp/prometheus-values.yaml
cp /tmp/prometheus-values.yaml /tmp/prometheus-values-custom.yaml
helm install logging prometheus-community/kube-prometheus-stack --create-namespace --namespace monitoring --values /tmp/prometheus-values-custom.yaml
kubectl get secrets logging-grafana -o jsonpath="{.data.admin-password}" | base64 -d && echo
kubectl port-forward pod/logging-grafana-56b5c6489b-tsch4 3000
```
