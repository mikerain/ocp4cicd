#create test and prod project, prod project will reuse test project's image
oc new-project demo-icbc-reuse-test-project
oc new-project demo-icbc-reuse-prod-project

oc policy add-role-to-user edit system:serviceaccount:demo-jenkins-shared:jenkins -n demo-icbc-reuse-test-project
oc policy add-role-to-user edit system:serviceaccount:demo-jenkins-shared:jenkins -n demo-icbc-reuse-prod-project


#create test app
oc new-app redhat-openjdk18-openshift:1.5~https://github.com/mikerain/log-collection.git --name log-collection -n demo-icbc-reuse-test-project
oc set triggers dc log-collection  --manual -n demo-icbc-reuse-test-project
oc expose service log-collection  -n demo-icbc-reuse-test-project


#create prod app in another project
oc new-app -i demo-icbc-reuse-test-project/log-collection:latest --name=log-collection  -n demo-icbc-reuse-prod-project
oc set triggers dc log-collection  --manual -n demo-icbc-reuse-prod-project

#give prod project use to access test project image
oc policy add-role-to-user   system:image-puller system:serviceaccount:demo-icbc-reuse-prod-project:default    --namespace=demo-icbc-reuse-test-project
oc expose service log-collection  -n demo-icbc-reuse-prod-project



#add bc env for china env:
#MAVEN_MIRROR_URL http://maven.aliyun.com/nexus/content/groups/public/

oc patch bc/log-collection --patch '{"spec": {"strategy": {"sourceStrategy": {"env": [{"name": "MAVEN_MIRROR_URL","value": "http://maven.aliyun.com/nexus/content/groups/public/"}]}}}}' -n demo-icbc-reuse-test-project
oc patch bc/log-collection --patch '{"spec": {"strategy": {"sourceStrategy": {"env": [{"name": "MAVEN_MIRROR_URL","value": "http://maven.aliyun.com/nexus/content/groups/public/"}]}}}}' -n demo-icbc-reuse-prod-project

