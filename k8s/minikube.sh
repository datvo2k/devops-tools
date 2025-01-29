#!/bin/bash

K8S_VERSION=v1.30.8

read -sp 'Name cluster? - ' NAME 

minikube start \
    --kubernetes-version=$K8S_VERSION \
	--driver=docker \
	--container-runtime=cri-o \
	--nodes 3 -p $NAME
  		



