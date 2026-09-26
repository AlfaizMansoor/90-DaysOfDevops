# Day 51 – Kubernetes Manifests and Your First Pods
## TASK-1
1. I create a file called nginx-pod.yaml:
    ```yml
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx-pod
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
    ```
2. I apply it:

  ```bash
  # Create a pod
  kubectl apply -f nginx-pod.yaml
  ```

3. Verify:
* `kubectl get pods`
* `kubectl get pods -o wide`
    - Wait until the STATUS shows Running. Then i explore:

#### Detailed info about the pod
* `kubectl describe pod nginx-pod`

#### Read the logs
* `kubectl logs nginx-pod`

#### Get a shell inside the container
* `kubectl exec -it nginx-pod -- /bin/bash`

#### Inside the container, run:
* `curl localhost:80`
* `exit`

#### Verify: Can you see the Nginx welcome page when you curl from inside the pod?
* **YES!** i can see the Nginx welcome page

## TASK-2
1. I write a new manifest busybox-pod.yaml from scratch:
  ```yml
  apiVersion: v1
  kind: Pod
  metadata:
    name: busybox-pod
    labels:
      app: busybox
      environment: dev
  spec:
    containers:
    - name: busybox
      image: busybox:latest
      command: ["sh", "-c", "echo Hello from BusyBox && sleep 3600"]
  ```

#### Apply and verify:
* `kubectl apply -f busybox-pod.yaml`
* `kubectl get pods`
* `kubectl logs busybox-pod`

#### Verify: Can you see "Hello from BusyBox" in the logs?
* **YES!** i can see "Hello from BusyBox"

## TASK-3
You have been using the declarative approach (writing YAML, then kubectl apply). Kubernetes also supports imperative commands:
  ```bash
  # Create a pod without a YAML file
  kubectl run redis-pod --image=redis:latest

  # Check it
  kubectl get pods
  ```

#### Now extract the YAML that Kubernetes generated:
  ```bash
  kubectl get pod redis-pod -o yaml
  ```
#### You can also use dry-run to generate YAML without creating anything:
  ```bash
  kubectl run test-pod --image=nginx --dry-run=client -o yaml
  ```

#### Verify: Save the dry-run output to a file and compare its structure with your nginx-pod.yaml. What fields are the same? What is different?

##### nginx-pod.yml
  ```bash
  apiVersion: v1
  kind: Pod
  metadata:
    labels:
      run: test-pod
    name: test-pod
  spec:
    containers:
    - image: nginx
      name: test-pod
      resources: {}
    dnsPolicy: ClusterFirst
    restartPolicy: Always
  status: {}
  ```
  ##### redis-pod
  
  ```bash
  apiVersion: v1
  kind: Pod
  metadata:
    creationTimestamp: "2026-09-26T08:00:56Z"
    generation: 1
    labels:
      run: redis-pod
    name: redis-pod
    namespace: default
    resourceVersion: "7970"
    uid: c21eedf7-56e8-4f7d-b69d-###########
  spec:
    containers:
    - image: redis:latest
      imagePullPolicy: Always
      name: redis-pod
      resources: {}
      terminationMessagePath: /dev/termination-log
      terminationMessagePolicy: File
      volumeMounts:
      - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: kube-api-access-#####
        readOnly: true
    dnsPolicy: ClusterFirst
    enableServiceLinks: true
    nodeName: uqaab-cluster-control-plane
    preemptionPolicy: PreemptLowerPriority
    priority: 0
    restartPolicy: Always
    schedulerName: default-scheduler
    securityContext: {}
    serviceAccount: default
    serviceAccountName: default
    terminationGracePeriodSeconds: 30
    tolerations:
    - effect: NoExecute
      key: node.kubernetes.io/not-ready
      operator: Exists
      tolerationSeconds: 300
    - effect: NoExecute
      key: node.kubernetes.io/unreachable
      operator: Exists
      tolerationSeconds: 300
    volumes:
    - name: kube-api-access-#####
      projected:
        defaultMode: 420
        sources:
        - serviceAccountToken:
            expirationSeconds: 3607
            path: token
        - configMap:
            items:
            - key: ca.crt
              path: ca.crt
            name: kube-root-ca.crt
        - downwardAPI:
            items:
            - fieldRef:
                apiVersion: v1
                fieldPath: metadata.namespace
              path: namespace
  status:
    conditions:
    - lastProbeTime: null
      lastTransitionTime: "2026-09-26T08:00:56Z"
      observedGeneration: 1
      status: "True"
      type: PodReadyToStartContainers
    - lastProbeTime: null
      lastTransitionTime: "2026-09-26T08:00:56Z"
      observedGeneration: 1
      status: "True"
      type: Initialized
    - lastProbeTime: null
      lastTransitionTime: "2026-09-26T08:01:06Z"
      observedGeneration: 1
      status: "True"
      type: Ready
    - lastProbeTime: null
      lastTransitionTime: "2026-09-26T08:01:06Z"
      observedGeneration: 1
      status: "True"
      type: ContainersReady
    - lastProbeTime: null
      lastTransitionTime: "2026-09-26T08:00:56Z"
      observedGeneration: 1
      status: "True"
      type: PodScheduled
    containerStatuses:
    - containerID:c6c62a1d5ffd6f6a#####b61f5f3b0d3e54d6c5b7184db62456fc42 containerd://  When you delete a standalone Pod, it is permanently gone and will never restart.
Because a standalone Pod was created directly (without a controller like a Deployment or ReplicaSet), there is no safety net watching over it.
      image: docker.io/library/redis:latest
      imageID: docker.io/library/redis@sha256:718f745deb7dfefeac6eed7041fc7ec9476b50e61b24793268###########
      lastState: {}
      name: redis-pod
      ready: true
      resources: {}
      restartCount: 0
      started: true
      state:
        running:
          startedAt: "2026-09-26T08:01:06Z"
      user:
        linux:
          gid: 0
          supplementalGroups:
          - 0
          uid: 0
      volumeMounts:
      - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: kube-api-access-#####
        readOnly: true
        recursiveReadOnly: Disabled
    hostIP: 172.20.0.8
    hostIPs:
    - ip: 172.20.0.8
    observedGeneration: 1
    phase: Running
    podIP: 10.244.0.7
    podIPs:
    - ip: 10.244.0.7
    qosClass: BestEffort
    resources: {}
    startTime: "2026-09-26T08:00:56Z"
  ```
## TASK-4
1. using the declarative approach (writing YAML, then kubectl apply). Kubernetes also supports imperative commands:
  ```bash
  # Check if the YAML is valid without actually creating the resource
  kubectl apply -f nginx-pod.yaml --dry-run=client

  # Validate against the cluster's API (server-side validation)
  kubectl apply -f nginx-pod.yaml --dry-run=server
  ```
2. Now i intentionally break my YAML.

#### Verify: What error does Kubernetes give when the image field is missing?
  ```bash
  nginx-pod     0/1     ErrImagePull   0          37m     app=nginx
  ```

## TASK-5
1. Labels are how Kubernetes organizes and selects resources. i added labels in my manifests 
  ```bash
  # List all pods with their labels
  kubectl get pods --show-labels

  # Filter pods by label
  kubectl get pods -l app=nginx
  kubectl get pods -l environment=dev

  # Add a label to an existing pod
  kubectl label pod nginx-pod environment=production

  # Verify
  kubectl get pods --show-labels

  # Remove a label
  kubectl label pod nginx-pod environment-
  ```
2. I write a manifest for a third pod with at least 3 labels (app, environment, team). Apply it and practice filtering.
  ```bash
  kubectl get pods --show-labels
  NAME          READY   STATUS    RESTARTS        AGE   LABELS
  boxbusy-pod   1/1     Running   0               3s    app=busybox,environment=dev,team=devuqaab
  busybox-pod   1/1     Running   0               18m   app=busybox,environment=dev
  nginx-pod     1/1     Running   1 (9m38s ago)   46m   app=nginx
  redis-pod     1/1     Running   0               17m   run=redis-pod
  ```
## TASK-6
1. Delete all the pods you created:
  ```bash
  # Delete by name
  kubectl delete pod nginx-pod
  kubectl delete pod busybox-pod
  kubectl delete pod redis-pod

  # Or delete using the manifest file
  kubectl delete -f nginx-pod.yaml

  # Verify everything is gone
  kubectl get pods
  ```

#### Difference between imperative (kubectl run) and declarative (kubectl apply -f)
* `kubectl run`  it basically used for running a pod
* `kubectl apply -f` it basically used for creating a pod

#### What happens when you delete a standalone Pod?
* When i delete a standalone Pod, it is permanently gone and will never restart. Because a standalone Pod was created directly (without a controller like a Deployment or ReplicaSet)

![alt text](<Screenshot From 2026-09-26 15-16-08.png>)