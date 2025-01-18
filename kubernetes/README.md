## How to deploy

### Start from metrics server

````kubectl apply -f metrics-server.yaml````

### Create deployment

````kubectl apply -f nginx-deployment.yaml````

### Create service

````kubectl apply -f nginx-service.yaml````

## Create horizontal pod scaling

````kubectl apply -f nginx-hpa.yaml````

## Test

Testing with hit the server with high load, if the pod is automatically scaling up, that mean the HPA is work
