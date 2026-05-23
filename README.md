# k8-project-infra

GitOps infrastructure for the Bookmarks application on Kubernetes.

The repository deploys a frontend and backend Helm chart with separate staging and production overlays. PostgreSQL is managed by CloudNativePG, with per-environment database clusters and generated application secrets. Ingress traffic is handled by ingress-nginx, and Flux reconciles the cluster state from this repository.

## kubectl get helmreleases -A

``
flux get helmreleases -A
NAMESPACE  	NAME          	REVISION	SUSPENDED	READY	MESSAGE                                                                                           
flux-system	cloudnative-pg	0.28.2  	False    	True 	Helm install succeeded for release cnpg-system/cloudnative-pg.v1 with chart cloudnative-pg@0.28.2	
flux-system	ingress-nginx 	4.15.1  	False    	True 	Helm install succeeded for release ingress-nginx/ingress-nginx.v1 with chart ingress-nginx@4.15.1	
production 	bookmarks-app 	0.1.0   	False    	True 	Helm install succeeded for release production/bookmarks-app.v1 with chart bookmarks-app@0.1.0    	
staging    	bookmarks-app 	0.1.0  
``

## flux get kustomizations -A

``
flux get kustomizations -A
NAMESPACE  	NAME         	REVISION          	SUSPENDED	READY	MESSAGE                              
flux-system	cnpg-operator	main@sha1:3897be34	False    	True 	Applied revision: main@sha1:3897be34	
flux-system	flux-system  	main@sha1:3897be34	False    	True 	Applied revision: main@sha1:3897be34	
flux-system	ingress-nginx	main@sha1:3897be34	False    	True 	Applied revision: main@sha1:3897be34	
flux-system	namespaces   	main@sha1:3897be34	False    	True 	Applied revision: main@sha1:3897be34	
flux-system	prod-app     	main@sha1:3897be34	False    	True 	Applied revision: main@sha1:3897be34	
flux-system	prod-db      	main@sha1:3897be34	False    	True 	Applied revision: main@sha1:3897be34	
flux-system	staging-app  	main@sha1:3897be34	False    	True 	Applied revision: main@sha1:3897be34	
flux-system	staging-db   	main@sha1:3897be34	False    	True 	Applied revision: main@sha1:3897be34
``

## kubectl get pods -A 

``
kubectl get pods -A
NAMESPACE            NAME                                            READY   STATUS    RESTARTS   AGE
cnpg-system          cloudnative-pg-5d48fbf669-mr7lj                 1/1     Running   0          114m
cnpg-system          cnpg-cloudnative-pg-54b848769f-69lpj            1/1     Running   0          5h29m
flux-system          helm-controller-665dbfdffb-hwrd2                1/1     Running   0          10h
flux-system          kustomize-controller-6d4575b9cc-c794g           1/1     Running   0          10h
flux-system          notification-controller-6d4fb7ff8b-f2kxf        1/1     Running   0          10h
flux-system          source-controller-6ddb98c984-cz78b              1/1     Running   0          10h
ingress-nginx        ingress-nginx-controller-6fd7d65fb-tf7cd        1/1     Running   0          5h39m
kube-system          coredns-66bc5c9577-kjmb8                        1/1     Running   0          10h
kube-system          coredns-66bc5c9577-wqjxk                        1/1     Running   0          10h
kube-system          etcd-desktop-control-plane                      1/1     Running   0          10h
kube-system          kindnet-x8gwl                                   1/1     Running   0          10h
kube-system          kube-apiserver-desktop-control-plane            1/1     Running   0          10h
kube-system          kube-controller-manager-desktop-control-plane   1/1     Running   0          10h
kube-system          kube-proxy-hn7sz                                1/1     Running   0          10h
kube-system          kube-scheduler-desktop-control-plane            1/1     Running   0          10h
local-path-storage   local-path-provisioner-5c4cdb564f-bm5cc         1/1     Running   0          10h
production           bookmarks-app-backend-65b5f8cb5f-bgp4f          1/1     Running   0          54m
production           bookmarks-app-backend-65b5f8cb5f-p2rxk          1/1     Running   0          55m
production           bookmarks-app-frontend-76f6f94647-nfr6d         1/1     Running   0          55m
production           bookmarks-app-frontend-76f6f94647-x8pxl         1/1     Running   0          55m
production           bookmarks-prod-db-1                             1/1     Running   0          73m
production           bookmarks-prod-db-2                             1/1     Running   0          73m
production           bookmarks-prod-db-3                             1/1     Running   0          73m
staging              bookmarks-app-backend-77d5c5559b-qhf5l          1/1     Running   0          6m33s
staging              bookmarks-app-frontend-6fb84f9c98-xt2xs         1/1     Running   0          25m
staging              bookmarks-staging-db-1                          1/1     Running   0          35m
``

## kubectl get ingress -A

``
kubectl get ingress -A
NAMESPACE    NAME                     CLASS   HOSTS               ADDRESS      PORTS   AGE
production   bookmarks-app-backend    nginx   api.prod.local      172.18.0.5   80      56m
production   bookmarks-app-frontend   nginx   app.prod.local      172.18.0.5   80      56m
staging      bookmarks-app-backend    nginx   api.staging.local   172.18.0.5   80      26m
staging      bookmarks-app-frontend   nginx   app.staging.local   172.18.0.5   80      26m
``

## kubectl get pods -n staging

``
kubectl get pods -n staging
NAME                                      READY   STATUS    RESTARTS   AGE
bookmarks-app-backend-77d5c5559b-qhf5l    1/1     Running   0          8m11s
bookmarks-app-frontend-6fb84f9c98-xt2xs   1/1     Running   0          27m
bookmarks-staging-db-1                    1/1     Running   0          37m
``

## kubectl get pods -n production

``
NAME                                      READY   STATUS    RESTARTS   AGE
bookmarks-app-backend-65b5f8cb5f-bgp4f    1/1     Running   0          57m
bookmarks-app-backend-65b5f8cb5f-p2rxk    1/1     Running   0          57m
bookmarks-app-frontend-76f6f94647-nfr6d   1/1     Running   0          57m
bookmarks-app-frontend-76f6f94647-x8pxl   1/1     Running   0          57m
bookmarks-prod-db-1                       1/1     Running   0          75m
bookmarks-prod-db-2                       1/1     Running   0          75m
bookmarks-prod-db-3                       1/1     Running   0          75m
``

## Self healing

``
kubectl get deploy -n staging                       
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
bookmarks-app-backend    1/1     1            1           36s
bookmarks-app-frontend   1/1     1            1           18m
irinashevcenko@MacBook-Pro-Irina ~ % kubectl delete deploy bookmarks-app-backend -n staging
deployment.apps "bookmarks-app-backend" deleted from staging namespace
irinashevcenko@MacBook-Pro-Irina ~ % kubectl get deploy -n staging                         
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
bookmarks-app-frontend   1/1     1            1           18m
irinashevcenko@MacBook-Pro-Irina ~ % flux reconcile helmrelease bookmarks-app -n staging   
► annotating HelmRelease bookmarks-app in staging namespace
✔ HelmRelease annotated
◎ waiting for HelmRelease reconciliation
✔ applied revision 0.1.0
irinashevcenko@MacBook-Pro-Irina ~ % kubectl get deploy -n staging                      
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
bookmarks-app-backend    0/1     1            0           9s
bookmarks-app-frontend   1/1     1            1           18m
irinashevcenko@MacBook-Pro-Irina ~ % kubectl get deploy -n staging
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
bookmarks-app-backend    1/1     1            1           18s
bookmarks-app-frontend   1/1     1            1           19m
``

````
sudo sh -c 'echo "127.0.0.1 api.staging.local app.staging.local" >> /etc/hosts'
irinashevcenko@MacBook-Pro-Irina ~ % curl -I http://app.staging.local                                                
HTTP/1.1 200 OK
Date: Sat, 23 May 2026 22:31:02 GMT
Content-Type: text/html
Content-Length: 433
Connection: keep-alive
Last-Modified: Fri, 22 May 2026 19:55:11 GMT
ETag: "6a10b49f-1b1"
Accept-Ranges: bytes

irinashevcenko@MacBook-Pro-Irina ~ % curl -i http://api.staging.local/health
HTTP/1.1 200 OK
Date: Sat, 23 May 2026 22:31:31 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 15
Connection: keep-alive
vary: Origin

{"status":"ok"}%                          
````
