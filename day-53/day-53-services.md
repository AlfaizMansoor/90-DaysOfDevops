# Day 53 – Kubernetes Servickind get 
## TASK-1
1. I create a Deployment that you will expose with Services. Create app-deployment.yaml:
    ```yml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: web-app
      labels:
        app: web-app
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: web-app
      template:
        metadata:
          labels:
            app: web-app
        spec:
          containers:
          - name: nginx
            image: nginx:1.25
            ports:
            - containerPort: 80
    ```
* Apply and run Deployment:
    ```bash
    kubectl apply -f app-deployment.yaml
    kubectl get pods -o wide
    ```

#### Verify: Are all 3 pods running? Note down their IP addresses.
* **YES!** all three pods are running
    ```bash
    NAME                       READY   STATUS    RESTARTS   AGE   IP           NODE              NOMINATED NODE   READINESS GATES
    web-app-6d948cd9f8-5k5wx   1/1     Running   0          71s   10.244.2.2   my-cluster-day53-worker2   <none>           <none>
    web-app-6d948cd9f8-f8ksx   1/1     Running   0          71s   10.244.1.2   my-cluster-day53-worker    <none>           <none>
    web-app-6d948cd9f8-lkq5k   1/1     Running   0          71s   10.244.2.3   my-cluster-day53-worker2   <none>           <none>
    ```

## TASK-2
* ClusterIP is the default Service type. It gives your Pods a stable internal IP that is only reachable from within the cluster.
1. Create clusterip-service.yaml:
    ```yml
    apiVersion: v1
    kind: Service
    metadata:
      name: web-app-clusterip
    spec:
      type: ClusterIP
      selector:
        app: web-app
      ports:
      - port: 80
        targetPort: 80
    ```
* Key fields:
    - selector.app: web-app — this Service routes traffic to all Pods with the label app: web-app
    - port: 80 — the port the Service listens on
    - targetPort: 80 — the port on the Pod to forward traffic to
2. Apply and run Service: 
    ```bash
    kubectl apply -f clusterip-service.yaml
    kubectl get services
    ```

### Now test it from inside the cluster:
    ```bash 
    # Run a temporary pod to test connectivity
    kubectl run test-client --image=busybox:latest --rm -it --restart=Never -- sh

    # Inside the test pod, run:
    wget -qO- http://web-app-clusterip
    exit
    ```

#### Verify: Does the Service respond? Try running the wget command multiple times — the Service distributes traffic across all healthy Pods.
* **YES!** after running wget commands multiple times

## TASK-3

**Kubernetes has a built-in DNS server. Every Service gets a DNS entry automatically:**

1. Test this:
    ```bash
    kubectl run dns-test --image=busybox:latest --rm -it --restart=Never -- sh

    # Inside the pod:
    # Short name (works within the same namespace)
    wget -qO- http://web-app-clusterip

    # Full DNS name
    wget -qO- http://web-app-clusterip.default.svc.cluster.local

    # Look up the DNS entry
    nslookup web-app-clusterip
    exit
    ```
* Both the short name and the full DNS name resolve to the same ClusterIP. In practice, you use the short name when communicating within the same namespace and the full name when reaching across namespaces.

#### Verify: What IP does nslookup return? Does it match the CLUSTER-IP from kubectl get services?
* **YES!** IP return when i run nslookup command is similar to CLUSTER-IP I get from kubectl
* **IP : 10.96.173.232**

## TASK-4
* A NodePort Service exposes your application on a port on every node in the cluster. This lets you access the Service from outside the cluster.

1. I Create nodeport-service.yaml:
    ```yml
    apiVersion: v1
    kind: Service
    metadata:
      name: web-app-nodeport
    spec:
      type: NodePort
      selector:
        app: web-app
      ports:
      - port: 80
        targetPort: 80
        nodePort: 30080
    ```
* nodePort: 30080 — the port opened on every node (must be in range 30000-32767)
* Traffic flow: <NodeIP>:30080 -> Service -> Pod:80

2. Apply and run Service
    ```bash
    kubectl apply -f nodeport-service.yaml
    kubectl get services
    ```
3. Access the service:
    ```bash
    # If using Minikube
    minikube service web-app-nodeport --url

    # If using Kind, get the node IP first
    kubectl get nodes -o wide
    # Then curl <node-internal-ip>:30080

    # If using Docker Desktop
    curl http://localhost:30080
    ```

#### Verify: Can you see the Nginx welcome page from your browser or terminal using the NodePort? 
* **YES!** i can see the nginx welcome page in my local.

## TASK-5
* In a cloud environment (AWS, GCP, Azure), a LoadBalancer Service provisions a real external load balancer that routes traffic to your nodes.

1. Create loadbalancer-service.yaml:
    ```yml
    apiVersion: v1
    kind: Service
    metadata:
      name: web-app-loadbalancer
    spec:
      type: LoadBalancer
      selector:
        app: web-app
      ports:
      - port: 80
        targetPort: 80
    ```

2. Apply and run Service
    ```bash
    kubectl apply -f loadbalancer-service.yaml
    kubectl get services
    
    # In another terminal, check again:
    kubectl get services
    ```
* In a real cloud cluster, the EXTERNAL-IP would be a public IP address or hostname provisioned by the cloud provider.

#### What does the EXTERNAL-IP column show? Why is it <pending> on a local cluster?
* The EXTERNAL-IP column in a Kubernetes Service output displays the publicly accessible IP address assigned to a LoadBalancer type service. This IP allows external traffic from outside your cluster to reach your applications.
* When you run a cluster locally (such as with kind, or Docker Desktop), this column will almost always get stuck in a <pending> state by default.

## TASK-6
1. Check all three services:
    ```bash
    kubectl get services -o wide
            NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
            kubernetes             ClusterIP      10.96.0.1       <none>        443/TCP        45m
            web-app-clusterip      ClusterIP      10.96.173.232   <none>        80/TCP         37m
            web-app-loadbalancer   LoadBalancer   10.96.169.183   <pending>     80:30839/TCP   15s
            web-app-nodeport       NodePort       10.96.191.214   <none>        80:30080/TCP   22m
    ```

2. Compare them:

| Type | Accessible From | Use Case |
|------|----------------|----------|
| ClusterIP | Inside the cluster only | Internal communication between services |
| NodePort | Outside via `<NodeIP>:<NodePort>` | Development, testing, direct node access |
| LoadBalancer | Outside via cloud load balancer | Production traffic in cloud environments |


Each type builds on the previous one:

    LoadBalancer creates a NodePort, which creates a ClusterIP
    So a LoadBalancer service also has a ClusterIP and a NodePort

3. Verify this:
    ```bash
    kubectl describe service web-app-loadbalancer
            Name:                     web-app-loadbalancer
            Namespace:                default
            Labels:                   <none>
            Annotations:              <none>
            Selector:                 app=web-app
            Type:                     LoadBalancer
            IP Family Policy:         SingleStack
            IP Families:              IPv4
            IP:                       10.96.169.###
            IPs:                      10.96.169.###
            Port:                     <unset>  80/TCP
            TargetPort:               80/TCP
            NodePort:                 <unset>  30839/TCP
            Endpoints:                10.244.1.2:8#####.3:80,10.244.2.2:80
            Session Affinity:         None
            External Traffic Policy:  Cluster
            Internal Traffic Policy:  Cluster
            Events:                   <none>
    ```

#### Verify: Does the LoadBalancer service also have a ClusterIP and NodePort assigned?
* **YES!** loadbalancer also have ClusterIP and NodePort

## TASK-7
    ```bash
    kubectl delete -f app-deployment.yaml
    kubectl delete -f clusterip-service.yaml
    kubectl delete -f nodeport-service.yaml
    kubectl delete -f loadbalancer-service.yaml

    kubectl get pods
    kubectl get services
    ```
* Note:- Only the built-in kubernetes service in the default namespace should remain.

#### Verify: Is everything cleaned up?
* **YES!** everything is cleaned

#### What problem Services solve and how they relate to Pods and Deployments
* If your frontend application tries to talk directly to a backend Pod's IP address, your app will break the moment that backend Pod is replaced.
* A Service solves this by providing a permanent, stable IP address and DNS name that sits in front of your dynamic Pods. It acts as a static gateway and built-in load balancer.
#### Your three Service manifests with an explanation of each type
#### The difference between ClusterIP, NodePort, and LoadBalancer

| Service Type | Where is it accessible? | Main Use Case |
|--------------|-------------------------|---------------|
| Cluster IP | Internal Only. | Communication between internal microservices (e.g., frontend talking to a backend database). |
| Node Port | External via the host node's IP and a high port (30000-32767)| .Quick local debugging or exposing services on bare-metal infrastructure without a cloud platform. |
| Load Balancer | External via a dedicated IP provisioned by a network provider. | Production applications facing the open public internet. |

#### How Kubernetes DNS works for service discovery?
* Whenever you create a new Service, Kubernetes automatically builds a DNS record pointing to that service's internal IP. The full domain format looks like this:
* <service-name>.<namespace>.svc.cluster.local

#### What Endpoints are and how to inspect them
* An Endpoint is an underground helper resource that Kubernetes builds automatically for every service.

![alt text](<Screenshot From 2026-09-28 11-10-55.png>)
![alt text](<Screenshot From 2026-09-28 12-16-09.png>)