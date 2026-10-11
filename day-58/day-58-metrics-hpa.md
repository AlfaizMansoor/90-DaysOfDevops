# Day 58 – Metrics Server and Horizontal Pod Autoscaler (HPA)
## TASK-1
1. I check if it is already running: 
    - `kubectl get pods -n kube-system | grep metrics-server`
2. If not, install it:
    - Kind/kubeadm: apply the official manifest from the metrics-server GitHub releases
        - `kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`
3. I wait for upto 60 seconds, then i verify it: 
    - `kubectl top nodes` and `kubectl top pods -A`

#### Verify: What is the current CPU and memory usage of your node?
* **CPU :-** **3m**
* **Memory :-** **20Mi**
    ```bash
    kube-system          metrics-server-746f8cfdd5-pq2ll                       3m           20Mi  
    ```
## TASK-2
1. Run :
    - `kubectl top nodes`, 
    - `kubectl top pods -A`, 
    - `kubectl top pods -A --sort-by=cpu`
2. `kubectl top` shows real-time usage, not requests or limits — these are different things
3. Data comes from the Metrics Server, which polls kubelets every 15 seconds

#### Verify: Which pod is using the most CPU right now?
* **kube-apiserver-cluster-day58-control-plane :- 205Mi** pod is using the most CPU
    ```bash
    kubectl top pods -A --sort-by=cpu
    NAMESPACE            NAME                                                  CPU(cores)   MEMORY(bytes)   
    kube-system          kube-apiserver-cluster-day58-control-plane            29m          205Mi   
    ```

![alt text](<Screenshot From 2026-10-11 12-04-46.png>)

## TASK-3
1. I write a Deployment manifest using the `registry.k8s.io/hpa-example` image (a CPU-intensive PHP-Apache server)
2. Set `resources.requests.cpu: 200m` — HPA needs this to calculate utilization percentages
3. Expose it as a Service: 
    - `kubectl expose deployment apache-deployment --port=80`

* Without CPU requests, HPA cannot work — this is the most common HPA setup mistake.

#### Verify: What is the current CPU usage of the Pod?
    ```bash
    NAME                                 CPU(cores)   MEMORY(bytes)   
    apache-deployment-78b8874bc6-jsvlw   1m           8Mi           
    ```
## TASK-4
1. Run: 
    - `kubectl autoscale deployment apache-deployment --cpu-percent=50 --min=1 --max=10`
2. Check: 
    - `kubectl get hpa and kubectl describe hpa apache-deployment`

This scales up when average CPU exceeds 50% of requests, and down when it drops below.

#### Verify: What does the TARGETS column show?
    ```bash
    NAME                REFERENCE                      TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
    apache-deployment   Deployment/apache-deployment   cpu: 0%/50%   1         10        1          2m26s
    ```
## TASK-5
1. I start a load generator: 
    - `kubectl run load-generator --image=busybox:1.36 --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://php-apache; done"`
2. Watch HPA: 
    - `kubectl get hpa php-apache --watch`
    Over 1-3 minutes, CPU climbs above 50%, replicas increase, CPU stabilizes
3. Stop the load: 
    - `kubectl delete pod load-generator`

#### Verify: How many replicas did HPA scale to under load?
* **Total : 1 replicas**

![alt text](<Screenshot From 2026-10-11 14-32-01.png>)

## TASK-6
1. I delete the imperative HPA: 
    - `kubectl delete hpa apache-hpa`
2. I write an HPA manifest using `autoscaling/v2` API with CPU target at `50%` utilization
3. Add a `behavior` section to control scale-up speed (no stabilization) and scale-down speed (300 second window)
4. I Apply and verify with 
    - `kubectl describe hpa`

![alt text](<Screenshot From 2026-10-11 14-31-32.png>)

#### Verify: What does the behavior section control?
* The behavior section controls the speed and velocity of scaling actions, preventing the cluster from over-reacting to short-lived metric changes.

* It breaks down into three key functions:
    - Stabilization Windows (stabilizationWindowSeconds)
    - Policies (policies)
    - Policy Selection

## TASK-7
1. Delete the HPA, Service, Deployment, and load-generator pod. Leave the Metrics Server installed.


#### What the Metrics Server is and why HPA needs it
* The Metrics Server is a cluster-wide collector that gathers live CPU and memory data from worker nodes.
* HPA needs it because the autoscaler itself cannot measure hardware usage. The Metrics Server acts as its eyes; without it, HPA has no data to trigger scaling actions.

#### How HPA calculates desired replicas
* HPA uses a straightforward mathematical formula to determine the necessary pod count:

![alt text](<Screenshot From 2026-10-11 15-36-44.png>)

* Example: If you have 2 replicas, a target of 50% CPU, and your current usage spikes to 100% CPU, the math is: 2 × (100 / 50) = 4. HPA will instantly scale out to 4 pods.

#### The difference between autoscaling/v1 and v2
* **autoscaling/v1** (Basic): Can only scale based on CPU utilization. It can only watch one metric at a time and uses rigid, unchangeable cluster speeds for scaling up and down.

* **autoscaling/v2** (Advanced): Can scale based on CPU, Memory, Custom metrics (like HTTP traffic volume), and External metrics. It can track multiple metrics simultaneously and gives you full control over scaling speeds via the custom behavior section.


