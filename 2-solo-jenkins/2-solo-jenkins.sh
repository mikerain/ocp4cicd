#!/bin/bash

oc new-project demo-solo-project --description "each project use each jenkin instance demo"
oc new-app jenkins-persistent --param MEMORY_LIMIT=1Gi --param DISABLE_ADMINISTRATIVE_MONITORS=true --param ENABLE_OAUTH=true -n demo-solo-project
oc set resources dc jenkins --limits=cpu=0.5,memory=1Gi --requests=cpu=0.1,memory=300Mi -n demo-solo-project

oc new-app redhat-openjdk18-openshift:1.5~https://github.com/mikerain/log-collection.git --name log-collection -n demo-solo-project
oc set triggers dc log-collection  --manual -n demo-solo-project

oc expose service log-collection

oc patch bc/log-collection --patch '{"spec": {"strategy": {"sourceStrategy": {"env": [{"name": "MAVEN_MIRROR_URL","value": "http://maven.aliyun.com/nexus/content/groups/public/"}]}}}}' -n demo-solo-project
