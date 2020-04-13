oc new-project demo-external-project

#run build in external jenkins to push imsge

oc new-app --docker-image=image-registry.openshift-image-registry.svc:5000/demo-external-project/log-collection:latest --name=log-collection -n demo-external-project

oc new-app -i demo-external-project/log-collection:latest --name=log-collection  -n demo-external-project 

oc expose service log-collection  -n demo-external-project


oc secrets new-dockercfg registry-mike-com --docker-server=registry.mike.com:5000 --docker-username=admin --docker-password=admin  -n demo-external-project --docker-email=qxu@redhat.com
oc secrets add serviceaccount/default secrets/registry-mike-com --for=pull

oc new-app --docker-image=registry.mike.com:5000/demo-external-project/log-collection-external:latest --name=log-collection-external  -n demo-external-project --allow-missing-images


oc expose service log-collection-external -n demo-external-project

oc create service clusterip log-collection-external  --tcp=8080:8080 -n demo-external-project
oc expose service log-collection-external 

