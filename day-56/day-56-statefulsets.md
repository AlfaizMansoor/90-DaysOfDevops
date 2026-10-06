# Day 56 – Kubernetes StatefulSets
## TASK-1
1. I create a Deployment with 3 replicas using nginx
2. I check the pod names — they are random (app-xyz-abc)
    - `kubectl get pods`
3. I delete a random pod and notice the replacement gets a different random name
    - `kubectl delete pod nginx-deployment-54b9c68f67-fzg8p`
4. Delete the Deployment before moving on.

#### Verify: Why would random pod names be a problem for a database cluster?
* Random pod names break database clusters because databases require a predictable identity to sync data, map storage, and route traffic safely.

## TASK-2
1s I write a Service manifest with `clusterIP: None` — this is a Headless Service
2. I set the selector to match the labels i will use on my StatefulSet pods
3. I Apply it and confirm that CLUSTER-IP must shows None

#### Verify: What does the CLUSTER-IP column show?
* **CLUSTER-IP** shows **None**

## TASK-3
1. I write a StatefulSet manifest with `serviceName` pointing to headless service
2. Set replicas to 3, and i use the nginx image
3. I added a `volumeClaimTemplates` section requesting `100Mi` of `ReadWriteOnce` storage
4. Apply and watch: kubectl get pods -l <your-label> -w

* Observe ordered creation — web-0 first, then web-1 after web-0 is Ready, then web-2.

5. Check the PVCs: 
    - `kubectl get pvc`
        ```bash
        kubectl get pods,pvc -l app=nginx-day56
        NAME        READY   STATUS    RESTARTS   AGE
        pod/web-0   1/1     Running   0          40s
        pod/web-1   1/1     Running   0          35s
        pod/web-2   1/1     Running   0          30s

        NAME                              STATUS   VOLUME                                     CAPACITYACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
        persistentvolumeclaim/www-web-0   Bound    pvc-3c3e04c9-c8a1-445a-8589-f667c14c17b9   100MiRWO            standard       <unset>                 40s
        persistentvolumeclaim/www-web-1   Bound    pvc-59f70c2c-9742-412a-9d99-26ae88745a3e   100MiRWO            standard       <unset>                 35s
        persistentvolumeclaim/www-web-2   Bound    pvc-b3b4efe6-a544-44ec-ae30-36ca99f2e862   100MiRWO            standard       <unset>                 30s
        ```

#### Verify: What are the exact pod names and PVC names?
* **Pod names:-**
    - pod/web-0
    - pod/web-1
    - pod/web-2

* **Pvc name:-**
    - www-web-0
    - www-web-1
    - www-web-2

## TASK-4
1. I Run a temporary busybox pod named "temporary-pod" and use nslookup to resolve `web-0.<your-headless-service>.default.svc.cluster.local` i use the same command for all web-0. web-1 and web-2
2. Confirm the IPs match `kubectl get pods -o wide`
    ```bash
    kubectl logs temporary-pod
    Server:         10.96.0.10
    Address:        10.96.0.10:53


    Name:   web-0.headless-service.default.svc.cluster.local
    Address: 10.244.1.8

    Server:         10.96.0.10
    Address:        10.96.0.10:53


    Name:   web-1.headless-service.default.svc.cluster.local
    Address: 10.244.2.6

    Server:         10.96.0.10
    Address:        10.96.0.10:53


Name:   web-2.headless-service.default.svc.cluster.local
Address: 10.244.1.9
    ```

#### Verify: Does the nslookup IP match the pod IP?
* **YES!** Pod IP matches to nslookup

## TASK-5 
1. I write unique data to each pod: 
    - `kubectl exec web-0 -- sh -c "echo 'Data from web-0' > /usr/share/nginx/index.html && cat /usr/share/nginx/index.html"`
2. I delete web-0:
    - `kubectl delete pod web-0`
* I wait for it to come back, then i check the data — it should still be "Data from web-0"

#### Verify: Is the data identical after pod recreation?
* I verified the data was still there

![alt text](<Screenshot From 2026-10-06 20-05-04.png>)

## TASK-6
1. Scale up to 5: 
    - `kubectl scale statefulset web --replicas=5`
2. Scale down to 3 — pods terminate in reverse order (web-4, then web-3)
    - `kubectl scale statefulset web --replicas=3`
        ```bash
        NAME            READY   STATUS    RESTARTS   AGE
        temporary-pod   1/1     Running   0          8m21s
        web-0           1/1     Running   0          4m49s
        web-1           1/1     Running   0          8m36s
        web-2           1/1     Running   0          8m35s
        web-3           1/1     Running   0          11s
        web-4           1/1     Running   0          6s
        ```
3. Check `kubectl get pvc` 
    ```bash
    NAME        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
    www-web-0   Bound    pvc-884fcea9-d227-41c1-bf97-9f7f550b9391   100Mi      RWO            standard       <unset>                 32m
    www-web-1   Bound    pvc-c11f3d37-98cc-491a-8ec3-1f0aceb92ecf   100Mi      RWO            standard       <unset>                 32m
    www-web-2   Bound    pvc-3bfb15d8-3393-4620-9114-c652ba5c3cbe   100Mi      RWO            standard       <unset>                 31m
    www-web-3   Bound    pvc-e0eaa681-b184-48fe-af6b-4105b00c93d3   100Mi      RWO            standard       <unset>                 89s
    www-web-4   Bound    pvc-f0ef1fa1-ae4a-4037-b61d-aeee5e5e06b4   100Mi      RWO            standard       <unset>                 84s
    ```
* All five PVCs still exist. Kubernetes keeps them on scale-down so data is preserved if you scale back up.

#### Verify: After scaling down, how many PVCs exist?
* After scaling down there are total 5 PVC's exist

## TASK-7
1. I delete the StatefulSet and the Headless Service
2. I Check `kubectl get pvc` — PVCs are still there (safety feature)
3. I delete PVCs manually

#### Verify: Were PVCs auto-deleted with the StatefulSet?
* **NO!** PVC's was not auto-deleted

#### What StatefulSets are and when to use them vs Deployments?
* A statefulset is a API object is used to manage stateful applications that require unique network, persistent storage, deployment and scaling.

* **Statefulsets :-** it manage pods that are not interchangeable, each pod gets a distinct identifier, and storage tied to PVC's data remains safe if the pod get deleted.

* **Deployments :-** Manage pods that are stateless and interchangeable. If a pod dies, a replacement is spun up with a brand-new random name and no attachment to the previous pod's specific identity or local state.


### Comparison Table

| Feature | Deployment | StatefulSet |
|---|---|---|
| Pod names | web-0 | Stable, ordered |
| Startup order | All at once | Ordered: web-0, then web-1 |
| Storage | Shared PVC | Each pod gets its own PVC |
| Network identity | No stable hostname | Stable DNS per pod |

![alt text](<Screenshot From 2026-10-06 21-50-17.png>)



![alt text](<Screenshot From 2026-10-06 21-50-55.png>)