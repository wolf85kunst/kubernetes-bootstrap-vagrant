# METALLB HELM INSTALLATION

### Installation with helm

```
helm repo add metallb https://metallb.github.io/metallb
helm install my-metallb metallb/metallb --version 0.13.10 --create-namespace --namespace metallb-system
```

```
cat <<EOF > /tmp/metallb.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.0.10-192.168.0.40
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
EOF
kubectl apply -f ./metallb.yaml
```

### test
```
kubectl create deploy nginx --image nginx
kubectl expose deploy nginx --port 80 --type LoadBalancer
INGRESS_EXTERNAL_IP=$(kubectl get svc nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo ${INGRESS_EXTERNAL_IP}
curl ${INGRESS_EXTERNAL_IP}
```

### Clean up
```
kubectl delete deploy nginx
kubectl delete svc nginx
```