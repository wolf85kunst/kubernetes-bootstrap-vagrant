# INGRESS CONTROLLER BARE-METAL HELM INSTALLATION 

### Install repos
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

### Install helm method
helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.7.0 --create-namespace --namespace ingress-nginx \
  --set controller.hostNetwork=true \
  --set controller.service.type=LoadBalancer \
  --set controller.ingressClass=nginx \
  --set controller.ingressClassResource.name=nginx \
  --set controller.ingressClassResource.controllerValue="matooma.com/ingress-nginx" \
  --set controller.ingressClassResource.enabled=true \
  --set controller.ingressClassByName=true 
  
### Testing 
#### App1
kubectl create deployment nginx --image=nginx --port=80
kubectl expose deployment nginx
kubectl create ingress nginx --class=nginx --rule nginx.example.com/=nginx:80

#### App1
kubectl create deployment httpd --image=httpd --port=80
kubectl expose deployment httpd
kubectl create ingress httpd --class=nginx --rule httpd.example.com/=httpd:80

INGRESS_EXTERNAL_IP=$(kubectl get svc --namespace=ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo ${INGRESS_EXTERNAL_IP}

curl $INGRESS_EXTERNAL_IP -H "Host: nginx.example.com"
curl $INGRESS_EXTERNAL_IP -H "Host: httpd.example.com"

### Clean up
kubectl delete deployment nginx
kubectl delete svc nginx
kubectl delete ingress nginx
kubectl delete deployment httpd
kubectl delete svc httpd
kubectl delete ingress httpd

