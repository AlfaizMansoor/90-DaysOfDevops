# Day 59 – Helm — Kubernetes Package Manager
## TASK-1
1. Install Helm (brew, curl script, or chocolatey depending on your OS)
    - `sudo snap install helm --classic`
2. Verify with:
    - `helm version` and `helm env`

* Three core concepts:
    - Chart — a package of Kubernetes manifest templates
    - Release — a specific installation of a chart in your cluster
    - Repository — a collection of charts (like a package repo)

#### Verify: What version of Helm is installed?
* **version.BuildInfo{Version:"v4.3.0", GitCommit:"bec5b06ed841fe5269972d864d5177944fd5970f", GitTreeState:"clean", GoVersion:"go1.27.1", KubeClientVersion:"v1.37"}**

## TASK-2
1. Add the Bitnami repository: 
    - `helm repo add bitnami https://charts.bitnami.com/bitnami`
2. Update: 
    - `helm repo update`
3. Search: 
    - `helm search repo nginx` and helm search repo bitnami

#### Verify: How many charts does Bitnami have?
* ***Approx: 120**

## TASK-3
1. I deploy nginx:
    - `helm install my-nginx bitnami/nginx`
2. Check what was created: 
    - `kubectl get all`
3. Inspect the release: 
    - `helm list`, 
    - `helm status my-nginx`, 
    - `helm get manifest my-nginx`

#### Verify: How many Pods are running? What Service type was created?
* 1 pod is running
* ClusterIP and LoadBalancer services 

![alt text](<Screenshot From 2026-10-11 19-43-07.png>)

## TASK-4
1. View defaults: 
    - `helm show values bitnami/nginx`
2. Install a custom release with: 
    - `--set replicaCount=3 --set service.type=NodePort`
3. Create a `custom-values.yaml` file with `replicaCount`, `service type`, and `resource limits`
4. Install another release using `-f custom-values.yaml`
5. Check overrides: 
    - `helm get values nginx`

#### Verify: Does the values file release have the correct replicas and service type?
* **YES!** value file have correct replicas and service type

## TASK-5
1. Upgrade: 
    - `helm upgrade my-nginx bitnami/nginx --set replicaCount=5`
2. Check history: 
    - `helm history my-nginx`
3. Rollback: 
    - `helm rollback my-nginx 1`

![alt text](<Screenshot From 2026-10-11 20-30-29.png>)

4. Check history again :
    - `helm history my-nginx`

#### Verify: How many revisions after the rollback?
* **There are total 3 revisions after the rollback**
    ```bash
    REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
    1               Sun Oct 11 19:39:24 2026        superseded      nginx-25.2.1    1.31.6          Install complete
    2               Sun Oct 11 20:23:38 2026        superseded      nginx-25.2.1    1.31.6          Upgrade complete
    3               Sun Oct 11 20:27:40 2026        deployed        nginx-25.2.1    1.31.6          Rollback to 1 
    ```

## TASK-6
1. Scaffold: 
    - `helm create my-app`
2. Explore the directory: "Chart.yaml", "values.yaml", "templates/deployment.yaml"
3. Look at the Go template syntax in `templates: {{ .Values.replicaCount }}`, `{{ .Chart.Name }}`
4. Edit "values.yaml" — set replicaCount to 3 and image to `nginx:1.25`
5. Validate: 
    - `helm lint my-app`
6. Preview: 
    - `helm template my-release ./my-app`

![alt text](<Screenshot From 2026-10-11 20-50-09.png>)

7. Install: 
    - `helm install my-release ./my-app`
8. Upgrade: 
    - `helm upgrade my-release ./my-app --set replicaCount=5`

#### Verify: After installing, 3 replicas? After upgrading, 5?
    ```bash
    REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
    1               Sun Oct 11 20:41:53 2026        superseded      my-app-0.1.0    1.16.0          Install complete
    2               Sun Oct 11 20:52:09 2026        deployed        my-app-0.1.0    1.16.0          Upgrade complete
    ```

## TASK-7
1. Uninstall all releases: 
    - `helm uninstall my-release`
2. Remove chart directory and values file

#### Verify: Does helm list show zero releases?
* `helm list` shows 0 releases
    ```bash
    alfaiz@alfaiz:~/90-DaysOfDevops/day-59/kubernetes-practice$ helm list
    NAME    NAMESPACE       REVISION        UPDATED STATUS  CHART   APP VERSION
    ```

#### What Helm is and the three core concepts
* Helm is the package manager for Kubernetes. Think of it like apt or snap on Ubuntu, but specifically designed to manage complex applications running inside a Kubernetes cluster. It packages multiple Kubernetes manifests (deployments, services, configmaps) into a single, deployable unit

* **Chart:** A blueprint or package containing all the resource definitions and templates needed to run an application inside a Kubernetes cluster.

* **Repository:** A shared online location where Helm charts are published, indexed, and made available for download (like an app store).

* **Release:** A running instance of a chart deployed inside your Kubernetes cluster. You can install the same chart multiple times, creating a new release each time (e.g., nginx-dev and nginx-prod).

#### How to install, customize, upgrade, and rollback
* **Install:** Deploys a chart to your cluster to create a new release.
    - `helm install my-nginx bitnami/nginx`

* **Customize:**Overrides default chart settings either inline using --set or by feeding a dedicated values file with -f
    - `helm install my-nginx bitnami/nginx --set replicaCount=3 -f custom-values.yaml`

* **Upgrade:** Modifies an existing, running release when configurations or image versions change.
    - `helm upgrade my-nginx bitnami/nginx -f custom-values.yaml`

* **Rollback:** Instantly reverts an application back to a previous working state if an upgrade introduces errors or crashes.
    - `helm rollback my-nginx 1`

#### The structure of a Helm chart and how Go templating works
* **The Chart Structure:**
    - **Chart.yaml:** A metadata file containing the chart's name, version, and apiVersion details.
    - **values.yaml:** The central configuration file holding the default variable parameters for your templates.
    - **templates/:** A folder containing Kubernetes yaml configuration blueprints (e.g., **deployment.yaml**, **service.yaml**).
    - **charts/:** An optional folder containing child charts that this main chart depends on.

#### Your custom-values.yaml with explanations
    ```yaml
    # 1. Scaling Configuration
    # Instructs Kubernetes to spin up exactly 2 running instances (pods) of this application.
    replicaCount: 2

    # 2. Networking Configuration
    # Defines how other applications inside the cluster access this NGINX server. 
    # 'ClusterIP' provides a stable, internal cluster-only virtual IP address.
    service:
      type: ClusterIP

    # 3. Resource Governance Configuration
    # Protects your cluster stability by defining bounds for CPU and Memory compute allocations.
    resources:
      # Requests: The gminimum allocation required on a cluster node to place the pod.
      requests:
        cpu: 250m        # Quarter of a CPU core
        memory: 256Mi    # 256 Megabytes
          # Limits: The maximum allocation. Kubernetes will kill/throttle the container if it exceeds this.
      limits:
        cpu: 500m        # Half a CPU core
        memory: 512Mi    # 512 Megabytes
    ```
