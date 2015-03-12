# RancherOS Vagrant

Deploy a local Kubernetes cluster on RancherOS using Vagrant/Virtualbox.

# IMPORTANT!

**Every time** you recreate your cluster, **run this:** 
    
    ./scripts/etcd-discovery

It generates `.etcd-discovery-url` file that is provisioned to your cluster nodes. 

WARNING: In case you try to reuse this file (e.g. you've forgot to run `./scripts/etcd-discovery` 
before `vagrant destroy -f && vagrant up`), the `etcd` nodes will try to become peers in already dead cluster. 


## Getting started
1.) Install dependencies

* Virtualbox (Tested with 4.3.24)
* Vagrant (Tested with 1.7.2)
* Kubernetes `kubectl` (Tested with 0.12.1)

You might also want to run a local Docker registry mirror:

    docker run -d -p 5000:5000 -e STANDALONE=false \
        -e MIRROR_SOURCE=https://registry-1.docker.io \
        -e MIRROR_SOURCE_INDEX=https://index.docker.io \
        registry

2.) Clone this project

```
git clone https://github.com/imikushin/rancheros-k8s-vagrant.git
cd rancheros-k8s-vagrant
```

3.) Up and Running

```
vagrant up
```

Watch for `==> node-01: MASTER_IP=...` message in the log. `MASTER_IP` value is your Kubernetes master node address. 

```
vagrant ssh node-01
vagrant ssh node-02
vagrant ssh node-03
```

Kubernetes launch script log is written to `/var/log/start.log`. You can watch it with

    tail -f /var/log/start.log

Set `KUBERNETES_MASTER=http://${MASTER_IP}:8080` environment variable on your host machine. 
Use Kubernetes `kubectl` utility (on your host) as usual to manage your Kubernetes cluster.  


## Upgrading RancherOS Versions

To upgrade the Vagrant box, refresh this repository from master.



### Customizing and configuring


To get a feel for how things work under the hood checkout the
[RancherOS Repo](https://github.com/rancherio/os) for details.

# License
Copyright (c) 2014-2015 [Rancher Labs, Inc.](http://rancher.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

