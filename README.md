# Helm Deployment acceleration app

This project deploys an application consisting of 3 microservices with helm; running locally in a kind cluster exposing one endpoint on localhost through an ingress.

## Requirements

- Docker
- kind (1.24)
- kubectl
- helm

## How-to

To create the kind cluster with an ingress controller and install the helm chart for each service run:

```bash
./deploy.sh
```

To clean up afterwards:
```bash
kind delete cluster
```