```bash
// Switch to istioinaction namespace
kubectl config set-context $(kubectl config current-context) --namespace=istioinaction

// clean up any resources
kubectl delete deployment,svc,gateway,virtualservice,destinationrule --all -n istioinaction


kubectl apply -f services/catalog/kubernetes/catalog.yaml

kubectl get pod -w

kubectl run -i -n default --rm --restart=Never dummy --image=curlimages/curl --command -- sh -c 'curl -s http://catalog.istioinaction/items'

// let\'s expose the catalog service to clients that live outside the cluster.

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

// Routing specific requests to v2

kubectl apply -f ch5/catalog-vs-v2-request.yaml

curl http://localhost/items -H "Host: catalog.istioinaction.io" -H "x-istio-cohort: internal"

curl http://localhost/items -H "Host: catalog.istioinaction.io"


// 5.2.6 Routing deep within a call graph

//Target: Istio ingress gateway -> webapp -> catalog v1 or catalog v2

kubectl delete gateway,virtualservice,destinationrule --all

kubectl apply -f services/webapp/kubernetes/webapp.yaml
kubectl apply -f services/webapp/istio/webapp-catalog-gw-vs.yaml

// issue calls again to the webapp service, we get responses to v1 or v2 of the catalog service as we saw ealier when accessing catalog directly
curl -H "Host: webapp.istioinaction.io" http://localhost/api/catalog


// let\'s create the VirtualService and DestinationRule to route all traffics to v1 of the catalog service
kubectl apply -f ch5/catalog-dest-rule.yaml
kubectl apply -f ch5/catalog-vs-v1-mesh.yaml

// Finally, we add request-based routing specifying that routing depends on whether the x-istio-cohort header is present and equals internal

curl http://localhost/api/catalog -H "Host: webapp.istioinaction.io" -H "x-istio-cohort: internal"


// 5.3 Traffic shifting

// reset all traffic to the v1 of the catalog service
kubectl apply -f ch5/catalog-vs-v1-mesh.yaml

// verify
for i in {1..10}; do curl http://localhost/api/catalog -H "Host: webapp.istioinaction.io"; done  


// let\'s route 10% of the traffic to v2 of catalog

kubectl apply -f ch5/catalog-vs-v2-10-90-mesh.yaml

// this will show the number of hits to v2 of catalog (a result close to 10 = 10% of 100 items)
for i in {1..100}; do curl -s http://localhost/api/catalog -H "Host: webapp.istioinaction.io" | grep -i imageUrl; done | wc -l


```
