# Day 52 – Kubernetes Namespaces and Deployments
## TASK-1
* Kubernetes comes with built-in namespaces. List them:
  ```bash
  kubectl get namespaces
  ```
#### You should see at least:
  - default — where your resources go if you do not specify a namespace
  - kube-system — Kubernetes internal components (API server, scheduler, etc.)
  - kube-public — publicly readable resources
  - kube-node-lease — node heartbeat tracking

#### Check what is running inside kube-system:
 * kubectl get pods -n kube-system`
  ```bash
  NAME                                                  READY   STATUS    RESTARTS    AGE
  coredns-66bc5c9577-2zm9w                              1/1     Running   0    58s
  coredns-66bc5c9577-56dcs                              1/1     Running   0    57s
  etcd-uqaab-cluster-control-plane                      1/1     Running   0    65s
  kindnet-8jnz2                                         1/1     Running   0    58s
  kube-apiserver-uqaab-cluster-control-plane            1/1     Running   0    65s
  kube-controller-manager-uqaab-cluster-control-plane   1/1     Running   0    65s
  kube-proxy-w988b                                      1/1     Running   3 (42s ago)   58s
  kube-scheduler-uqaab-cluster-control-plane            1/1     Running   0    65s
  ```

#### Verify: How many pods are running in kube-system?
* Total: 8 pods are running in **kube-system**

## TASK-2
1. Create two namespaces — one for a development environment and one for staging:
  ```bash
  kubectl create namespace dev
  kubectl create namespace staging
  ```
#### Verify they exist:
  ```bash
  kubectl get namespaces
  ```
2. I also create a namespace from a manifest:
  ```yml
  # namespace.yaml
  apiVersion: v1
  kind: Namespace
  metadata:
    name: production
  ```
  ```bash
  kubectl apply -f namespace.yaml
  ```
3. run a pod in a specific namespace:
  ```bash
  kubectl run nginx-dev --image=nginx:latest -n dev
  kubectl run nginx-staging --image=nginx:latest -n staging
  ```
#### List pods across all namespaces:
* kubectl get pods -A
  ```bash
  NAME                 STATUS   AGE
  default              Active   34s
  dev                  Active   34s
  kube-node-lease      Active   34s
  kube-public          Active   34s
  kube-system          Active   34s
  local-path-storage   Active   30s
  production           Active   34s
  staging              Active   34s
  ```

#### Verify: Does kubectl get pods show these pods? What about kubectl get pods -A?
* **YES!** `kubectl get pods -A` display every single pods across all the namespaces

## TASK-3
1. Create a file nginx-deployment.yaml:
  ```yml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: nginx-deployment
    namespace: dev
    labels:
      app: nginx
  spec:
    replicas: 3
    selector:
      matchLabels:
        app: nginx
    template:
      metadata:
        labels:
          app: nginx
      spec:
        containers:
        - name: nginx
          image: nginx:1.24
          ports:
          - containerPort: 80
  ```
* Key differences from a standalone Pod:
  - kind: Deployment instead of kind: Pod
  - apiVersion: apps/v1 instead of v1
  - replicas: 3 tells Kubernetes to maintain 3 identical pods
  - selector.matchLabels connects the Deployment to its Pods
  - template is the Pod template — the Deployment creates Pods using this blueprint

* I Apply it:
  ```bash
  kubectl apply -f nginx-deployment.yaml
  ```

* Check the result:
  ```bash
  kubectl get deployments -n dev

    - NAME               READY   UP-TO-DATE   AVAILABLE   AGE
      nginx-deployment   3/3     3            3           22s

  kubectl get pods -n dev

    - NAME                                READY   STATUS    RESTARTS   AGE
      nginx-deployment-6d8cd7bf4b-978qg   1/1     Running   0          33s
      nginx-deployment-6d8cd7bf4b-j6sr4   1/1     Running   0          33s
      nginx-deployment-6d8cd7bf4b-w6ngk   1/1     Running   0          33s
      nginx-dev                           1/1     Running   0          7m9s
  ```

#### Verify: What do the READY, UP-TO-DATE, and AVAILABLE columns mean in the deployment output?
* You just ran kubectl apply. The containers take a few seconds to pull and boot:
  - READY = 1/3: 1 Pod is ready, 2 are still creating.
  - UP-TO-DATE = 3: Kubernetes has successfully targeted all 3 replicas to use your new blueprint.
  - AVAILABLE = 1: Only 1 Pod is ready to accept user traffic immediately.

## TASK-4 
  ```bash
  # List pods
  kubectl get pods -n dev

  # Delete one of the deployment's pods (use an actual pod name from your output)
  kubectl delete pod nginx-deployment-6d8cd7bf4b-w6ngk -n dev

  # Immediately check again
  kubectl get pods -n dev
  ```

#### Verify: Is the replacement pod's name the same as the one you deleted, or different?
* **NO!** the name of pod was different from the deleted one.

## TASK-5
* Change the number of replicas:
  ```bash
  # Scale up to 5
  kubectl scale deployment nginx-deployment --replicas=5 -n dev
  kubectl get pods -n dev
      NAME                                READY   STATUS    RESTARTS   AGE
      nginx-deployment-6d8cd7bf4b-5rg8f   1/1     Running   0          22s
      nginx-deployment-6d8cd7bf4b-8pbs2   1/1     Running   0          22s
      nginx-deployment-6d8cd7bf4b-978qg   1/1     Running   0          10m
      nginx-deployment-6d8cd7bf4b-j6sr4   1/1     Running   0          10m
      nginx-deployment-6d8cd7bf4b-q9d7h   1/1     Running   0          4m37s
      nginx-dev                           1/1     Running   0          16m


  # Scale down to 2
  kubectl scale deployment nginx-deployment --replicas=2 -n dev
  kubectl get pods -n dev
      NAME                                READY   STATUS    RESTARTS   AGE
      nginx-deployment-6d8cd7bf4b-978qg   1/1     Running   0          10m
      nginx-deployment-6d8cd7bf4b-j6sr4   1/1     Running   0          10m
      nginx-dev   

  ```

#### Verify: When you scaled down from 5 to 2, what happened to the extra pods?
* the 3 extra Pods are gracefully terminated and permanently removed from the cluster.

## TASK-6
1. Update the Nginx image version to trigger a rolling update:
  ```bash
  kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev
  ```
2. Watch the rollout in real time:
  ```bash
  kubectl rollout status deployment/nginx-deployment -n dev
  ```
* Kubernetes replaces pods one by one — old pods are terminated only after new ones are healthy. This means zero downtime.

3. Check the rollout history:
  ```bash
  kubectl rollout history deployment/nginx-deployment -n dev
  ```
4. Now roll back to the previous version:
  ```bash
  kubectl rollout undo deployment/nginx-deployment -n dev
  kubectl rollout status deployment/nginx-deployment -n dev
  ```
5. Verify the image is back to the previous version:
  ```bash
  kubectl describe deployment nginx-deployment -n dev | grep Image
      Image:         nginx:1.24
  ```

#### Verify: What image version is running after the rollback?
* **YES!** image version is running after the rollback

## TASK-7
  ```bash
  kubectl delete deployment nginx-deployment -n dev
  kubectl delete pod nginx-dev -n dev
  kubectl delete pod nginx-staging -n staging
  kubectl delete namespace dev staging production

  Deleting a namespace removes everything inside it. Be very careful with this in production.

  kubectl get namespaces
  kubectl get pods -A
  ```
#### Verify: Are all your resources gone?
* **YES!** all my resources are gone.

#### What namespaces are and why you would use them
* A namespace is a virtual/logical cluster inside the cluster it isolate resources groups from another.

#### What happens when you delete a Pod managed by a Deployment vs a standalone Pod
* **Standalone pod:-** when we delete an standalone pod it will deleted permanently.
* **Deployment pod:-** it is supervised, and can be recover instantly, The ReplicaSet immediately spins up a brand-new Pod with a new name to restore the desired count. 

#### How scaling works (both imperative and declarative)
* **Imperative :-** we can scale by replicating pods according to our needs from 2 to 5
* **Declarative :-** we can delete extra pods we don't need anymore from 5 to 2

#### How rolling updates and rollbacks work
* How a Rolling Update Works:
  - When you trigger an update, the Deployment controller creates a new parallel ReplicaSet for version v2.
  - It brings up a small batch of v2 Pods.
  - Once the new v2 Pods pass their health checks and become READY, the Deployment terminates an equal number of old v1 Pods.
  - This gradual trade-off continues until all running Pods are v2 and the old v1 ReplicaSet is scaled down to 0.
* How a Rollback Works:
  - If your new v2 version contains a major bug or crashes upon release, you can instantly undo the rollout.The Mechanism: Kubernetes keeps a history of your past deployment configurations (revisions). When you initiate a rollback, it reverses the rolling update process by scaling the old v1 ReplicaSet back up and scaling the broken v2 ReplicaSet down to 0.

![alt text](<Screenshot From 2026-09-27 19-14-28.png>)