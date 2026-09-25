# Day 50 – Kubernetes Architecture and Cluster Setup
## TASK-1
#### Why was Kubernetes created? What problem does it solve that Docker alone cannot?
* Kubernetes is created for scaling, when software industry wants to shift from small scale to large scale to run a multiple containers when it needs. It self heals crashed container, high availability  and scaling, load balancing,

* Kubernetes can scale from one docker container to multiple container, if server dies application moves to another working server, can be use as load balancer.

#### Who created Kubernetes and what was it inspired by?
* Kubernetes is created by Google in 2014

* Kubernetes was heavily inspired by Borg, an internal cluster management system that Google had been using secretly for over a decade.

#### What does the name "Kubernetes" mean?
* The word Kubernete means Pilot.

## TASK-2

#### Control Plane (Master Node):

    API Server — the front door to the cluster, every command goes through it
    etcd — the database that stores all cluster state
    Scheduler — decides which node a new pod should run on
    Controller Manager — watches the cluster and makes sure the desired state matches reality

#### Worker Node:

    kubelet — the agent on each node that talks to the API server and manages pods
    kube-proxy — handles networking rules so pods can communicate
    Container Runtime — the engine that actually runs containers (containerd, CRI-O)

![alt text](my-architecture.png)

#### What happens when you run kubectl apply -f pod.yaml? Trace the request through each component.
* `kubectl apply -f pod.yml` it cretes a pod in a cluster,
    
#### What happens if the API server goes down?
* API server is located in control panel that means if API server is goes down then the whole server will collapse.

#### What happens if a worker node goes down?
* If a worker node goes down then kubectl start doing it's work it shifts the work to the another worker node and kubectl heals it by self.

## TASK-3

### Installing kubectl
#### Linux (amd64)

* `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"`
* `chmod +x kubectl`
* `sudo mv kubectl /usr/local/bin/`

## TASK-4
Choose one of the following. Both give you a fully functional Kubernetes cluster on your machine.

Option A: kind (Kubernetes in Docker)

### Install kind
#### Linux
* `curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64`
* `chmod +x ./kind`
* `sudo mv ./kind /usr/local/bin/kind`

#### Create a cluster
* `kind create cluster --name devops-cluster`

#### Verify
* `kubectl cluster-info`
* `kubectl get nodes`

Option B: minikube

### Install minikube
#### Linux
* `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64`
* `sudo install minikube-linux-amd64 /usr/local/bin/minikube`

#### Start a cluster
* `minikube start`

#### Verify
* `kubectl cluster-info`
* `kubectl get nodes`

#### Which one did you choose and why?
* I choose **kind** because it's easy to understand for a beginner.

## TASK-5
* Now that your cluster is running, explore it:

#### See cluster info
* `kubectl cluster-info`
    ```bash
    Kubernetes control plane is running at https://127.0.0.1:37567
    CoreDNS is running at https://127.0.0.1:37567/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

    ```
#### List all nodes
* `kubectl get nodes`
    ```bash
    NAME                             STATUS   ROLES           AGE   VERSION
    devuqaab-cluster-control-plane   Ready    control-plane   8h    v1.36.4
    devuqaab-cluster-worker          Ready    <none>          8h    v1.36.4
    devuqaab-cluster-worker2         Ready    <none>          8h    v1.36.4
    ```

#### Get detailed info about your node
* `kubectl describe node <node-name>`
    ```bash
    Name:               devuqaab-cluster-worker
    Roles:              <none>
    Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=devuqaab-cluster-worker
                    kubernetes.io/os=linux
    Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
    CreationTimestamp:  Fri, 25 Sep 2026 15:08:16 +0530
    Taints:             <none>
    Unschedulable:      false
    Lease:
      HolderIdentity:  devuqaab-cluster-worker
      AcquireTime:     <unset>
      RenewTime:       Fri, 25 Sep 2026 23:44:34 +0530
    Conditions:
      Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
      ----             ------  -----------------                 ------------------                ------                       -------
      MemoryPressure   False   Fri, 25 Sep 2026 23:40:05 +0530   Fri, 25 Sep 2026 15:08:16 +0530   KubeletHasSufficientMemory   kubelet has sufficient memory available
      DiskPressure     False   Fri, 25 Sep 2026 23:40:05 +0530   Fri, 25 Sep 2026 15:08:16 +0530   KubeletHasNoDiskPressure     kubelet has no disk pressure
      PIDPressure      False   Fri, 25 Sep 2026 23:40:05 +0530   Fri, 25 Sep 2026 15:08:16 +0530   KubeletHasSufficientPID      kubelet has sufficient PID available
      Ready            True    Fri, 25 Sep 2026 23:40:05 +0530   Fri, 25 Sep 2026 15:08:27 +0530   KubeletReady                 kubelet is posting ready status
    Addresses:
      InternalIP:  172.20.0.3
      Hostname:    devuqaab-cluster-worker
    Capacity:
      cpu:                12
      ephemeral-storage:  4879#######
      hugepages-1Gi:      0
      hugepages-2Mi:      0
      memory:             1512#######
      pods:               110
    Allocatable:
      cpu:                12
      ephemeral-storage:  4879#######
      hugepages-1Gi:      0
      hugepages-2Mi:      0
      memory:             1512#######
      pods:               110
    System Info:
      Machine ID:                 f31025b0c39a4c2c8ec############
      System UUID:                ae1bdad1-aa51-453c-9478-############
      Boot ID:                    e5291f97-09d5-4352-9956-############
      Kernel Version:             7.0.0-31-generic
     OS Image:                   Debian GNU/Linux 13 (trixie)
      Operating System:           linux
      Architecture:               amd64
      Container Runtime Version:  containerd://2.3.4
      Kubelet Version:            v1.36.4
    PodCIDR:                      10.244.2.0/24
    PodCIDRs:                     10.244.2.0/24
    ProviderID:                   kind://docker/devuqaab-cluster/devuqaab-cluster-worker
    Non-terminated Pods:          (3 in total)
     Namespace                   Name                CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
      ---------                   ----                ------------  ----------  ---------------  -------------  ---
     default                     nginx-pod           0 (0%)        0 (0%)      0 (0%)           0 (0%)         8h
     kube-system                 kindnet-hljzn       100m (0%)     0 (0%)      50Mi (0%)        0 (0%)         8h
      kube-system                 kube-proxy-4d292    0 (0%)        0 (0%)      0 (0%)           0 (0%)         8h
    Allocated resources:
      (Total limits may be over 100 percent, i.e., overcommitted.)
      Resource           Requests   Limits
      --------           --------   ------
      cpu                100m (0%)  0 (0%)
      memory             50Mi (0%)  0 (0%)
      ephemeral-storage  0 (0%)     0 (0%)
      hugepages-1Gi      0 (0%)     0 (0%)
      hugepages-2Mi      0 (0%)     0 (0%)
    Events:              <none>
    ```

#### List all namespaces
* `kubectl get namespaces`
    ```bash
    NAME                 STATUS   AGE
    default              Active   8h
    kube-node-lease      Active   8h
    kube-public          Active   8h
    kube-system          Active   8h
    local-path-storage   Active   8h
    ```
#### See ALL pods running in the cluster (across all namespaces)
* `kubectl get pods`
    ```bash
    NAMESPACE            NAME                                                     READY   STATUS    RESTARTS       AGE
    default              nginx-pod                                                1/1     Running   2 (3h4m ago)   8h
    kube-system          coredns-589f44###########                                 1/1     Running   2 (3h4m ago)   8h
    kube-system          coredns-589f44###########                                 1/1     Running   2 (3h4m ago)   8h
    kube-system          etcd-devuqaab-cluster-control-plane                      1/1     Running   7 (3h4m ago)   8h
    kube-system          kindnet-#####                                            1/1     Running   2 (3h4m ago)   8h
    kube-system          kindnet-#####                                            1/1     Running   2 (3h4m ago)   8h
    kube-system          kindnet-#####                                            1/1     Running   2 (3h4m ago)   8h
    kube-system          kube-apiserver-devuqaab-cluster-control-plane            1/1     Running   7 (3h4m ago)   8h
    kube-system          kube-controller-manager-devuqaab-cluster-control-plane   1/1     Running   3 (3h4m ago)   8h
    kube-system          kube-proxy-#####                                         1/1     Running   2 (3h4m ago)   8h
    kube-system          kube-proxy-#####                                         1/1     Running   2 (3h4m ago)   8h
    kube-system          kube-proxy-#####                                         1/1     Running   2 (3h4m ago)   8h
    kube-system          kube-scheduler-devuqaab-cluster-control-plane            1/1     Running   3 (3h4m ago)   8h
    local-path-storage   local-path-provisioner-56c46#####-#####                  1/1     Running   4 (3h4m ago)   8h

    ```

#### Look at the pods running in the kube-system namespace:
* `kubectl get pods -n kube-system`
    ```bash
    NAME                                                     READY   STATUS    RESTARTS       AGE
    coredns-589f44dc88-#####                                 1/1     Running   2 (3h5m ago)   8h
    coredns-589f44dc88-#####                                 1/1     Running   2 (3h5m ago)   8h
    etcd-devuqaab-cluster-control-plane                      1/1     Running   7 (3h5m ago)   8h
    kindnet-#####                                            1/1     Running   2 (3h5m ago)   8h

    ```

* I see pods like `etcd`, `kube-apiserver`, `kube-scheduler`, `kube-controller-manager`, `coredns`, and `kube-proxy`. These are the architecture components i drew in Task 2 — is running as pods inside the cluster.

#### Verify: Can you match each running pod in kube-system to a component in your architecture diagram?
* **YES!**

### Install minikube

#### Linux
* `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64`
* `sudo install minikube-linux-amd64 /usr/local/bin/minikube`

#### Verify
* `kubectl cluster-info`
    ```bash
    Kubernetes control plane is running at https://127.0.0.1:37567
    CoreDNS is running at https://127.0.0.1:37567/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

    ```
#### `kubectl get nodesrify`: Can you match each running pod in kube-system to a component in your architecture diagram?

## TASK-6
Build muscle memory with cluster operations:

#### Delete your cluster
* `kind delete cluster --name devops-cluster`
    ```bash
    Deleting cluster "devops-cluster" ...

    ```
#### Recreate it
* `kind create cluster --name devops-cluster`
    ```bash
    Creating cluster "devops-cluster" ...
     ✓ Ensuring node image (kindest/node:v1.37.0) 🖼️
     ✓ Preparing nodes 📦  
     ✓ Writing configuration 📜 
     ✓ Starting control-plane 🕹️ 
     ✓ Installing CNI 🔌 
     ✓ Installing StorageClass 💾 
    Set kubectl context to "kind-devops-cluster"
    You can now use your cluster with:

    kubectl cluster-info --context kind-devops-cluster

    ```

#### Verify it is back
* `kubectl get nodes`
    ```bash
    Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂
    NAME                           STATUS     ROLES           AGE   VERSION
    devops-cluster-control-plane   NotReady   control-plane   4s    v1.37.0

    ```
#### Check which cluster kubectl is connected to
* `kubectl config current-context`

    ```bash
    kind-devops-cluster
    ```
#### List all available contexts (clusters)
* `kubectl config get-contexts`
     ```bash
    CURRENT   NAME                    CLUSTER                 AUTHINFO                NAMESPACE
    *        kind-devops-cluster     kind-devops-cluster     kind-devops-cluster     
          kind-devuqaab-cluster   kind-devuqaab-cluster   kind-devuqaab-cluster   

    ```

#### See the full kubeconfig
* `kubectl config view`
    ```bash
    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority-data: DATA+OMITTED
        server: https://127.0.0.1:37567
      name: kind-devops-cluster
    - cluster:
        certificate-authority-data: DATA+OMITTED
        server: https://127.0.0.1:39853
      name: kind-devuqaab-cluster
    contexts:
    - context:
        cluster: kind-devops-cluster
        user: kind-devops-cluster
      name: kind-devops-cluster
    - context:
        cluster: kind-devuqaab-cluster  
        user: kind-devuqaab-cluster
      name: kind-devuqaab-cluster
    current-context: kind-devops-cluster
    kind: Config
    users:
    - name: kind-devops-cluster
      user:
        client-certificate-data: DATA+OMITTED
        client-key-data: DATA+OMITTED
    - name: kind-devuqaab-cluster
      user:
        client-certificate-data: DATA+OMITTED
        client-key-data: DATA+OMITTED
    ```
#### What is a kubeconfig? Where is it stored on your machine?
* Kubeconfig is a kubernetes menifest file for kubectl configuration
* It is stored in **/home/username/.kube/config**
