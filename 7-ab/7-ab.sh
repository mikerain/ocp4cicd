oc new-project demo-icbc-ab-project
oc policy add-role-to-user edit system:serviceaccount:demo-jenkins-shared:jenkins -n demo-icbc-ab-project

oc new-app redhat-openjdk18-openshift:1.5~https://github.com/mikerain/log-collection.git --name log-collection-a -n demo-icbc-ab-project
oc new-app redhat-openjdk18-openshift:1.5~https://github.com/mikerain/log-collection.git#test --name log-collection-b -n demo-icbc-ab-project

oc set triggers dc log-collection-a  --manual -n demo-icbc-ab-project
oc set triggers dc log-collection-b  --manual -n demo-icbc-ab-project

oc patch bc/log-collection-a --patch '{"spec": {"strategy": {"sourceStrategy": {"env": [{"name": "MAVEN_MIRROR_URL","value": "http://maven.aliyun.com/nexus/content/groups/public/"}]}}}}' -n demo-icbc-ab-project

oc patch bc/log-collection-b --patch '{"spec": {"strategy": {"sourceStrategy": {"env": [{"name": "MAVEN_MIRROR_URL","value": "http://maven.aliyun.com/nexus/content/groups/public/"}]}}}}' -n demo-icbc-ab-project


oc expose service log-collection-a  --name=log-collection -n demo-icbc-ab-project

oc patch route/log-collection --patch '{"spec": {"alternateBackends": [{"kind": "Service","name": "log-collection-b","weight": 100}]}}'
