# HELM USAGE TIPS
### MORE --> https://helm.sh/docs/intro/cheatsheet/

```
# list repos
helm repo list |grep "prometheus\|NAME"
NAME                	URL                                               
prometheus-community	https://prometheus-community.github.io/helm-charts

# List releases
helm list -n stack
NAME	NAMESPACE	REVISION	UPDATED                                 	STATUS  	CHART                        	APP VERSION
prom	stack    	4       	2023-06-30 11:30:21.301263874 +0200 CEST	deployed	kube-prometheus-stack-45.22.0	v0.63.0    

# Search repo
helm search repo prometheus-community
helm search repo prometheus-community/kube-prometheus-stack --versions |head -n 5
NAME                                      	CHART VERSION	APP VERSION	DESCRIPTION                                       
prometheus-community/kube-prometheus-stack	47.1.0       	v0.66.0    	kube-prometheus-stack collects Kubernetes manif...
prometheus-community/kube-prometheus-stack	47.0.1       	v0.66.0    	kube-prometheus-stack collects Kubernetes manif...
prometheus-community/kube-prometheus-stack	47.0.0       	v0.66.0    	kube-prometheus-stack collects Kubernetes manif...
prometheus-community/kube-prometheus-stack	46.8.0       	v0.65.2    	kube-prometheus-stack collects Kubernetes manif...

# Get values file from chart
helm show values prometheus-community/kube-state-metrics 
helm show values prometheus-community/kube-state-metrics > /tmp/prometheus-operator-values.yaml

# Install a chart
helm install prom prometheus-community/kube-prometheus-stack --create-namespace --namespace stack --values /tmp/prometheus-operator-values.yaml

# Upgrade a chart
helm upgrade prom prometheus-community/kube-prometheus-stack --namespace stack -f /tmp/prometheus-operator-values.yaml --version 45.22.0 --description "downgrade to 45.22.0"
helm upgrade prom prometheus-community/kube-prometheus-stack --namespace stack --set "grafana.adminPassword=test" --description "change password with set"
helm upgrade prom prometheus-community/kube-prometheus-stack --namespace stack --set "grafana.ingress.enabled=true" --description "add ingress #2"

# List of revision
helm history -n stack prom 
REVISION	UPDATED                 	STATUS    	CHART                        	APP VERSION	DESCRIPTION         
1       	Fri Jun 30 11:00:34 2023	superseded	kube-prometheus-stack-45.0.0 	v0.63.0    	Install complete    
2       	Fri Jun 30 11:16:46 2023	superseded	kube-prometheus-stack-47.1.0 	v0.66.0    	Upgrade complete    
3       	Fri Jun 30 11:25:30 2023	superseded	kube-prometheus-stack-47.1.0 	v0.66.0    	update password     
4       	Fri Jun 30 11:30:21 2023	deployed  	kube-prometheus-stack-45.22.0	v0.63.0    	downgrade to 45.22.0

# rollback
helm -n stack rollback prom 1
Rollback was a success! Happy Helming!

# Get info from chart
helm template -n stack prometheus-community/kube-state-metrics
helm show values -n stack prometheus-community/kube-state-metrics 

# Get info from installed
helm get manifest -n stack prom
helm get values -n stack prom
helm get notes -n stack prom 
helm get all -n stack prom 
```







