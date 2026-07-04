```bash
// Switch to istioinaction namespace
kubectl config set-context $(kubectl config current-context) --namespace=istioinaction

// clean up any resources
kubectl delete deployment,svc,gateway,virtualservice,destinationrule --all -n istioinaction


kubectl apply -f services/catalog/kubernetes/catalog.yaml

kubectl get pod -w

kubectl run -i -n default --rm --restart=Never dummy --image=curlimages/curl --command -- sh -c 'curl -s http://catalog.istioinaction/items'

// let's expose the catalog service to clients that live outside the cluster.

kubectl apply -f ch5/catalog-gateway.yaml


// we need create virtualservice resource that routes traffic to catalog service

k apply -f ch5/catalog-vs.yaml

curl http://localhost/items -H "Host: catalog.istioinaction.io"

// deploy v2 of the catalog service
kubectl apply -f services/catalog/kubernetes/catalog-deployment-v2.yaml

for in in {1..10}; do curl http://localhost/items -H "Host: catalog.istioinaction.io"; printf "\n\n"; done


// how to route all traffic to v1 of the catalog service

// we need to give Istio a hint about how to identify which workloads are v1 and which ones are v2
// For Istio, we create a DestinationRule that specifies different versions as subsets

kubectl apply -f ch5/catalog-dr.yaml

kubectl apply -f ch5/catalog-vs-v1.yaml

for in in {1..10}; do curl http://localhost/items -H "Host: catalog.istioinaction.io"; printf "\n\n"; done


```
