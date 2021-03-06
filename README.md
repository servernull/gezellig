# gezellig
A FaaS application demonstrating image analysis that leverages [OpenFaaS](https://openfaas.com)

![](gezellig.png)

### Screenshots

![](images.png)
![](analytics.png)
![](links.png)

### Setup
<details>
  <summary>Click to expand</summary>
  
```bash
# create a cluster.  (minikube in this example)
minikube start --vm-driver=hyperkit \
  --memory 4048mb \
  --kubernetes-version='v1.15.0'

# install k3sup
curl -SLfs https://get.k3sup.dev | sudo sh

# install openfaas
k3sup app install openfaas --load-balancer

# Get the faas-cli
curl -SLsf https://cli.openfaas.com | sudo sh

# Forward the gateway to your machine
kubectl rollout status -n openfaas deploy/gateway
kubectl port-forward -n openfaas svc/gateway 8080:8080 &

# If basic auth is enabled, you can now log into your gateway:
PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
echo -n $PASSWORD | faas-cli login --username admin --password-stdin

# OPTIONAL run grafana in openfaas namespace
kubectl -n openfaas run \
--image=stefanprodan/faas-grafana:4.6.3 \
--port=3000 \
grafana
kubectl -n openfaas expose deployment grafana \
--type=NodePort \
--name=grafana
GRAFANA_PORT=$(kubectl -n openfaas get svc grafana -o jsonpath="{.spec.ports[0].nodePort}")
GRAFANA_URL=http://localhost:$GRAFANA_PORT/dashboard/db/openfaas
port-forward deployment/grafana 3000:3000 -n openfaas &

# OPTIONAL install metrics-server
k3sup app install metrics-server

# update default timeouts to 5 minutes
kubectl get deploy/gateway -n openfaas -o yaml > gateway.yaml
#.. edit gateway.yaml
# change these values
#        - name: read_timeout
#          value: 65s
#        - name: write_timeout
#          value: 65s
#        - name: upstream_timeout
#          value: 60s
#          ...
#        - name: read_timeout
#          value: 60s
#        - name: write_timeout
#          value: 60s
# to the values
#        - name: read_timeout
#          value: 300s
#        - name: write_timeout
#          value: 300s
#        - name: upstream_timeout
#          value: 295s
#          ...
#        - name: read_timeout
#          value: 300s
#        - name: write_timeout
#          value: 300s
# apply changes
kubectl apply -f gateway.yaml

# start elasticsearch
docker-compose up -d

# install function templates
faas-cli template pull
faas template pull https://github.com/openfaas-incubator/golang-http-template
```
</details>

### Installation
```
faas-cli deploy -f stack.yml

# navigate to http://localhost:8080/function/openfaas-imageui
```

### Function dependencies
* [openfaas-imagecrawler](https://github.com/servernull/openfaas-imagecrawler)
* [openfaas-imagecrawlerdemux](https://github.com/servernull/openfaas-imagecrawlerdemux)
* [openfaas-exif](https://github.com/servernull/openfaas-exif)
* [openfaas-exiffeed](https://github.com/servernull/openfaas-exiffeed)
* [openfaas-opennsfw](https://github.com/servernull/openfaas-opennsfw)
* [openfaas-opennsfwfeed](https://github.com/servernull/openfaas-opennsfwfeed)
* [inception-function](https://github.com/faas-and-furious/inception-function)
* [openfaas-inceptionfeed](https://github.com/servernull/openfaas-inceptionfeed)
* [openfaas-elastic](https://github.com/servernull/openfaas-elastic)
* [openfaas-imagesearch](https://github.com/servernull/openfaas-imagesearch)
* [openfaas-imageui](https://github.com/servernull/openfaas-imageui)

### Dependencies
* [OpenFaaS](http://openfaas.com)
* [faas-cli](https://github.com/openfaas/faas-cli)
* [Elasticsearch](https://www.elastic.co/)
* [Docker]()
* [Minikube]()

Inspired by [cozyish](https://github.com/scottleedavis/cozyish)
