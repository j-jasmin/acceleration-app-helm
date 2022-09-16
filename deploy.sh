#!/bin/sh

BLUE='\033[0;34m'
NOCOLOR='\033[0m'

echo "${BLUE}Creating kind cluster...${NOCOLOR}"
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  labels:
    ingress-ready: true
EOF

echo "${BLUE}Installing nginx ingress controller...${NOCOLOR}"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "${BLUE}Waiting for ingress controller pod to be ready...${NOCOLOR}"
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo "${BLUE}Installing helm charts...${NOCOLOR}"
helm upgrade --install acceleration-a k8s/chart -f k8s/values/acceleration-a.yaml
helm upgrade --install acceleration-dv k8s/chart -f k8s/values/acceleration-dv.yaml
helm upgrade --install acceleration-calc k8s/chart -f k8s/values/acceleration-calc.yaml

echo "${BLUE}Waiting for pods to be ready...${NOCOLOR}"
kubectl wait --namespace default \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=service

echo "${BLUE}Sending requests to localhost/calc - not 100% stable ;)${NOCOLOR}"
COUNTER=1 

while [ $COUNTER -lt 100 ]
do
  curl "http://localhost:80/calc?vf=200&vi=5&t=123"; echo 
  COUNTER=$(($COUNTER+1))
  sleep 2
done 
