# Day 57 – Resource Requests, Limits, and Probes
## TASK-1
1. I write a Pod manifest with `resources.requests (cpu: 100m, memory: 128Mi)` and `resources.limits (cpu: 250m, memory: 256Mi)`
2. I apply and inspect with `kubectl describe pod` — look for the Requests, Limits, and QoS Class sections
3. Since requests and limits differ, the QoS class is 'Burstable'. If equal, it would be 'Guaranteed'. If missing, 'BestEffort'.

* CPU is in millicores: 100m = 0.1 CPU. Memory is in mebibytes: 128Mi.
* Requests = guaranteed minimum (scheduler uses this for placement). Limits = maximum allowed (kubelet enforces at runtime).

#### Verify: What QoS class does your Pod have?
* **Burstable**
    ```bash
    Volumes:
      kube-api-access-fwclf:
        Type:                    Projected (a volume that contains injected data from multiple sources)
        TokenExpirationSeconds:  3607
        ConfigMapName:           kube-root-ca.crt
        Optional:                false
        DownwardAPI:             true
    QoS Class:                   Burstable
    Node-Selectors:              <none>
    Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
    ```

## TASk-2
1. I write a Pod manifest using the polinux/stress image with a `memory` limit of `100Mi`
2. Set the stress command to allocate 200M of memory: `command: ["stress"] args: ["--vm", "1", "--vm-bytes", "200M", "--vm-hang", "1"]`
3. I apply and watch — the container gets killed immediately

* CPU is throttled when over limit. Memory is killed — no mercy.
* Check `kubectl describe pod` for Reason: OOMKilled and Exit Code: 137 (128 + SIGKILL).

#### Verify: What exit code does an OOMKilled container have?
* **Exit Code: 137**

## TASK-3
1. I write a Pod manifest requesting `cpu: 100` and `memory: 128Gi`
2. I apply and check — STATUS stays Pending forever
3. Run `kubectl describe pod` and read the Events — the scheduler says exactly why: insufficient resources

#### Verify: What event message does the scheduler produce?
    ```bash
    Events:
      Type     Reason            Age   From               Message
      ----     ------            ----  ----               -------
      Warning  FailedScheduling  23s   default-scheduler  0/2 nodes are available: 1 Insufficient cpu, 1 Insufficient memory, 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }. preemption: 0/2 nodes are available: 1 No preemption victims found for incoming pod, 1 Preemption is not helpful for scheduling.
    ```

## TASK-4
* A liveness probe detects stuck containers. If it fails, Kubernetes restarts the container.

1. I write a Pod manifest with a busybox container that creates `/tmp/healthy` on startup, then deletes it after 30 seconds
2. I add a liveness probe using exec that runs `cat /tmp/healthy`, with `periodSeconds: 5` and `failureThreshold: 3`
3. After the file is deleted, 3 consecutive failures trigger a restart. Watch with `kubectl get pod -w`

#### Verify: How many times has the container restarted?
* **Total : 6 Times**

## TASK-5
* A readiness probe controls traffic. Failure removes the Pod from Service endpoints but does NOT restart it.

1. I write a Pod manifest with nginx and a `readinessProbe` using `httpGet` on `path: /` `port: 80`
2. I Expose it as a Service: 
    - `kubectl expose pod readiness-pod --port=80 --name=readiness-svc`
3. Check: 
    - `kubectl get endpoints readiness-svc`  — the Pod IP is listed
4. Break the probe: 
    - `kubectl exec readiness-pod -- rm /usr/share/nginx/html/index.html`

#### Verify: When readiness failed, was the container restarted?
* Removes the Pod from Service endpoints. Traffic stops routing to it.

    ```bash
    Events:
      Type     Reason     Age                From               Message
      ----     ------     ----               ----               -------
      Normal   Scheduled  8m57s              default-scheduler  Successfully assigned default/readiness-pod to cluster-day57-worker
      Normal   Pulling    8m57s              kubelet            spec.containers{readiness}: Pulling image "nginx:latest"
      Normal   Pulled     8m55s              kubelet            spec.containers{readiness}: Successfully pulled image "nginx:latest" in 1.685s (1.685s including waiting). Image size: 63873678 bytes.
      Normal   Created    8m55s              kubelet            spec.containers{readiness}: Created container readiness
      Normal   Started    8m55s              kubelet            spec.containers{readiness}: Started container readiness
      Warning  Unhealthy  7s (x10 over 87s)  kubelet            spec.containers{readiness}: Readiness probe failed: HTTP probe failed with statuscode: 403
    ```

## TASK-6
* A startup probe gives slow-starting containers extra time. While it runs, liveness and readiness probes are disabled.

1. I write a Pod manifest where the container takes 20 seconds to start (e.g., `sleep 20 && touch /tmp/started`)
2. I add a `startupProbe` checking for `/tmp/started` with `periodSeconds: 5` and `failureThreshold: 12` (60 second budget)
3. I add a `livenessProbe` that checks the same file — it only kicks in after startup succeeds

#### Verify: What would happen if failureThreshold were 2 instead of 12?
* changing the failureThreshold to 2 cuts your initialization budget down from 60 seconds to just 10 seconds (5 seconds x 2 attempts)
* Because the container takes 20 seconds to boot up and create /tmp/healthy, the startup probe will exhaust both allowed attempts and fail before the application ever gets a chance to become ready. This forces the kubelet to kill and restart the container every 11 seconds, trapping your Pod in a continuous crash loop where it will never start up successfully.

## TASK-7

1. I delete all pods and services you created.

#### Requests vs limits (scheduling vs enforcement)
* **Requests :-** When you apply a pod, the scheduler looks at the total capacity of each node, subtracts the resources already requested by running pods, and checks if the node has enough leftover room to fit the new request.

* **Limits :-** Once the pod is running on a node, the container runtime (like containerd) configures the host operating system's kernel mechanics (cgroups) to physically restrict how much hardware the container is allowed to draw.

#### What happens when CPU or memory limits are exceeded
* **CPU :-** it temporarily restrict the container's access to CPU cycles. The application will feel laggy or slow, but it won't crash.

* **Memory :-** If the application hits its limit, the host's Kernel OOM Killer steps in, targets the container process, and kills it instantly to protect host node stability.

#### Liveness vs readiness vs startup probes
* **Liveness :-** detects deadlocks, freezes, or crashed application loops. If it fails, the container restarts.

* **Readiness :-** if the container is ready to accept user network requests. If it fails, the pod is isolated from Services to stop traffic, but it is never restarted.

* **Startup Probe :-** Disables all other checks during boot to give slow applications extra time to start. If it fails, the container restarts.


![alt text](<Screenshot From 2026-10-10 19-36-33.png>)
\
\
![alt text](<Screenshot From 2026-10-10 19-51-55.png>)
\
\
![alt text](<Screenshot From 2026-10-10 21-32-08.png>)
\
\
![alt text](<Screenshot From 2026-10-10 21-33-02.png>)
\
\
![alt text](<Screenshot From 2026-10-10 21-33-11.png>)
