#!/bin/bash

oc new-project demo-s2i-project --description "s2i project build demo"

oc new-app redhat-openjdk18-openshift:1.5~https://github.com/mikerain/log-collection.git --name log-collection -n demo-s2i-project

oc expose service log-collection  -n demo-s2i-project

