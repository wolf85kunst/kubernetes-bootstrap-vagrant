# RBAC - créer un acces utilisateur

````
# Generate key & csr
cd /tmp
openssl genrsa -out hugo.key 2048
openssl req -new -key hugo.key -out hugo.csr

# recuperer csr
# cat hugo.csr | base64 | tr -d "\n"
request=$(cat hugo.csr | base64 | tr -d "\n")

# Integrer le csr à la ressource CertificateSigningRequest
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: hugo
spec:
  request: ${request}
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF

# approuvé csr et vérifier
kubectl get csr
kubectl certificate approve hugo
kubectl get csr


# Enregistrer le certificat
kubectl get csr/hugo -o yaml
kubectl get csr hugo -o jsonpath='{.status.certificate}'| base64 -d > hugo.crt

# lister le bundle de certificats
$ ls -1 |grep hugo
hugo.crt
hugo.csr
hugo.key

# Create role & rolebinding
kubectl create role developer --verb=create --verb=get --verb=list --verb=update --verb=delete --resource=pods
kubectl create rolebinding developer-binding-hugo --role=developer --user=hugo

# Configure kubeconfig
kubectl config set-credentials hugo --client-key=hugo.key --client-certificate=hugo.crt --embed-certs=true
kubectl config set-context hugo --cluster=kind-kind --user=hugo
kubectl config use-context hugo

# clean up
kubectl config delete-context hugo
kubectl delete role developer 
kubectl delete rolebindings developer-binding-hugo
```
