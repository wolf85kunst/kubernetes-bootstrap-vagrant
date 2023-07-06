# CREATE USER WITH TOKEN AUTH

### Help !
> https://www.ibm.com/docs/fr/cloud-paks/cp-management/2.3.x?topic=kubectl-using-service-account-tokens-connect-api-server

### /!\ Get certificat in a pod
```
# Get certificate from a pod
kubectl exec -it ellie -- cat /var/run/secrets/kubernetes.io/serviceaccount/..data/ca.crt > /tmp/ca.crt
```

### Create user
```
# Define user
user=coco

# Create namespace
kubectl create namespace ${user}-ns
kubens ${user}-ns

# create serviceAccount
kubectl create serviceaccount ${user}-sa

# Create secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${user}-secret
  annotations:
    kubernetes.io/service-account.name: ${user}-sa
type: kubernetes.io/service-account-token
EOF

# Get generated token
kubectl describe secrets ${user}-secret
token=$(kubectl get secrets ${user}-secret -o jsonpath={.data.token} |base64 -d)
echo ${token}

# create role and bindingRole
kubectl create role ${user}-role --verb=get --verb=list --verb=watch --resource=pods
kubectl create rolebinding ${user}-binding --serviceaccount=${user}-ns:${user}-sa --role=${user}-role

# Create new kubeconfig for testing
touch ~/.kube/${user}
chmod 600 ~/.kube/${user}
KUBECONFIG=$HOME/.kube/${user}

kubectl config set-cluster ${user}-cluster --server=https://127.0.0.1:45669 --certificate-authority=/tmp/ca.crt
kubectl config set-context ${user}-ctx --cluster=coco-cluster
kubectl config set-credentials ${user} --token=${token}
kubectl config set-context ${user}-ctx --user=${user}
kubectl config set-context ${user}-ctx --namespace ${user}-ns
kubectl config use-context ${user}-ctx 
kubectl config get-contexts
kubectl get pods
```

### clean up
```
kubectl delete ns ${user}-ns
rm ~/.kube/${user}
```
