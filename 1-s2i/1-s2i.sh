#!/bin/bash

oc new-project demo-s2i-project --description "s2i project build demo"

oc new-app redhat-openjdk18-openshift:1.5~https://github.com/mikerain/log-collection.git --name log-collection -n demo-s2i-project

oc expose service log-collection  -n demo-s2i-project

#add bc env for china env:
#MAVEN_MIRROR_URL http://maven.aliyun.com/nexus/content/groups/public/

oc patch bc/log-collection --patch '{"spec": {"strategy": {"sourceStrategy": {"env": [{"name": "MAVEN_MIRROR_URL","value": "http://maven.aliyun.com/nexus/content/groups/public/"}]}}}}' -n demo-s2i-project

