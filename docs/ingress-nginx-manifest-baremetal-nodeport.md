# Installation
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/deploy.yaml
```

# Patch
```
kubectl patch deployment ingress-nginx-controller -n ingress-nginx -p '{"spec":{"template":{"spec":{"hostNetwork":true}}}}'
```

# Affichier la version du Nginx ingress controller
```
POD_NAMESPACE=ingress-nginx
POD_NAME=$(kubectl get pods -n $POD_NAMESPACE -l app.kubernetes.io/name=ingress-nginx --field-selector=status.phase=Running -o name)
kubectl exec $POD_NAME -n $POD_NAMESPACE -- /nginx-ingress-controller --version
```

# Vérifier l'état de l'ingress controller
```
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```
  
# Test de l'ingress Controller avec une application 
```
kubectl create deployment demo --image=httpd --port=80
kubectl expose deployment demo
kubectl create ingress demo-localhost --class=nginx --rule="demo.localdev.me/*=demo:80"
```

# Test ultime !
```
curl http://demo.localdev.me --resolve demo.localdev.me:80:192.168.10.13
<html><body><h1>It works!</h1></body></html>
```
