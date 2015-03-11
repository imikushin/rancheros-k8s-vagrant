# RancherOS Vagrant

Deploy a local Kubernetes cluster on RancherOS using Vagrant/Virtualbox.

# !!! Important !!!

**Every time** you recreate your cluster, run this: 
    
    ./scripts/etcd-discovery

It generates `.etcd-discovery-url` file that is provisioned to your cluster nodes.  

## Getting started
1.) Install dependencies

* Virtualbox (Tested with 4.3.24)
* Vagrant (Tested with 1.7.2)
* Kubernetes `kubectl` (Tested with 0.12.0)

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

Set `KUBERNETES_MASTER=http://${MASTER_IP}:8080` environment variable. 
Use Kubernetes `kubectl` utility as usual to manage your Kubernetes cluster.  


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

