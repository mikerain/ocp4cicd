oc new-project demo-icbc-bluegreen-project
oc policy add-role-to-user edit system:serviceaccount:demo-jenkins-shared:jenkins -n demo-icbc-bluegreen-project

oc new-app redhat-openjdk18-openshift:1.5~https://github.com/mikerain/log-collection.git --name log-collection-blue -n demo-icbc-bluegreen-project
oc new-app redhat-openjdk18-openshift:1.5~https://github.com/mikerain/log-collection.git#test --name log-collection-green -n demo-icbc-bluegreen-project

oc set triggers dc log-collection-blue  --manual -n demo-icbc-bluegreen-project
oc set triggers dc log-collection-green  --manual -n demo-icbc-bluegreen-project

oc expose service log-collection-blue  --name=log-collection -n demo-icbc-bluegreen-project
