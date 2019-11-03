#!/bin/sh

#https://github.com/openfaas/faas/issues/1016 (make sure 600s timeouts)

# edit the timeouts to a at least 300s
helm repo add openfaas https://openfaas.github.io/faas-netes

helm repo update && \
helm upgrade openfaas --install openfaas/openfaas \
    --namespace openfaas  \
    --set basic_auth=true \
    --set functionNamespace=openfaas-fn \
    --set ingress.enabled=true \
    --set gateway.scaleFromZero=true \
    --set gateway.readTimeout=300s \
    --set gateway.writeTimeout=300s \
    --set gateway.upstreamTimeout=295s \
    --set faasnetesd.readTimeout=300s \
    --set faasnetesd.writeTimeout=300s \
    --set gateway.replicas=2 \
    --set queueWorker.replicas=2


#run the port forwarding to openfaas
kubectl port-forward -n openfaas svc/gateway 8080:8080 &

