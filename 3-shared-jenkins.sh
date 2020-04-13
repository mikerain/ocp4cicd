oc new-project demo-jenkins-shared --description "shared jenkins instance"

oc new-app jenkins-persistent --param MEMORY_LIMIT=1Gi --param DISABLE_ADMINISTRATIVE_MONITORS=true --param ENABLE_OAUTH=true
oc set resources dc jenkins --limits=cpu=1,memory=1Gi --requests=cpu=0.3,memory=300Mi


oc new-project demo-icbc-project --description "use shared jenkins icbc project"
oc new-project demo-ccb-project --description "use shared jenkins ccb project"


oc policy add-role-to-user edit system:serviceaccount:demo-jenkins-shared:jenkins -n demo-icbc-project
oc policy add-role-to-user edit system:serviceaccount:demo-jenkins-shared:jenkins -n demo-ccb-project


oc policy add-role-to-user admin icbc -n demo-icbc-project
oc policy add-role-to-user admin ccb -n demo-ccb-project

oc policy add-role-to-user edit ccb -n demo-jenkins-shared
oc policy add-role-to-user edit icbc -n demo-jenkins-shared


oc new-app redhat-openjdk18-openshift:1.5~https://github.com/mikerain/log-collection.git --name log-collection -n demo-ccb-project
oc expose service log-collection  -n demo-ccb-project
oc set triggers dc log-collection  --manual -n demo-ccb-project


oc new-app redhat-openjdk18-openshift:1.5~https://github.com/mikerain/log-collection.git --name log-collection -n demo-icbc-project
oc expose service log-collection  -n demo-icbc-project
oc set triggers dc log-collection  --manual -n demo-icbc-project

