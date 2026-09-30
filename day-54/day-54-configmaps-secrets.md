# Day 54 – Kubernetes ConfigMaps and Secrets
## TASK-1
1. I use kubectl create configmap with --from-literal to create a ConfigMap called app-config with keys APP_ENV=production, APP_DEBUG=false, and APP_PORT=8080.
    - `kubectl create configmap --from-literal=APP_DEBUG=false --from-literal=APP_PORT=8080`
2. I inspect it with kubectl describe configmap app-config and kubectl get configmap app-config -o yaml
    - `kubectl describe configmap app-config`
    - `kubectl get configmap app-config -o yaml`
3. data is stored as plain text — no encoding, no encryption.

#### Verify: Can you see all three key-value pairs?
* **YES!** i can see the all three key-value pairs.

## TASK-2 
1. I write a custom Nginx config file **"healthcheck-nginx.conf"** that adds a /health endpoint returning "healthy"
    ```conf
    server {
        listen       80;
        server_name  localhost;

        # Custom health check endpoint
        location = /health {
            access_log off;
            default_type text/plain;
            return 200 'healthy';
        }

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }
    }
    ```

2. I create a ConfigMap from this file using kubectl create configmap nginx-config --from-file=default.conf=<your-file>
    - `kubectl create configmap nginx-config --from-file=default.conf=healthcheck-nginx.conf`

3. The key name (default.conf) becomes the filename when mounted into a Pod

#### Verify: Does kubectl get configmap nginx-config -o yaml show the file contents?
* **YES!** it shows the file contents.
    ```bash
    apiVersion: v1
    data:
      default.conf: |+
        server {
            listen       80;
            server_name  localhost;

            # Custom health check endpoint
            location = /health {
                access_log off;
                default_type text/plain;
                return 200 'healthy';
            }

            location / {
                root   /usr/share/nginx/html;
                index  index.html index.htm;
            }
        }

    kind: ConfigMap
    metadata:
      creationTimestamp: "2026-09-29T17:01:36Z"
      name: nginx-config
      namespace: default
      resourceVersion: "41505"
      uid: b24eedea-7baa-4ddf-b09f-01551d90ce01
    ```

## TASk-3
1. I write a Pod manifest that uses envFrom with configMapRef to inject all keys from app-config as environment variables. Use a busybox container that prints the values.
    ```yml
    apiVersion: v1
    kind: Pod
    metadata:
      name: busybox-env-pod
    spec:
      restartPolicy: Never
      containers:
        - name: busybox
          image: busybox:1.36
          command: ["sh", "-c", "echo '--- Env Values ---' && env | grep APP_"]
          envFrom:
            - configMapRef:
                name: app-config
    ```

2. I write a second Pod manifest that mounts nginx-config as a volume at /etc/nginx/conf.d. Use the nginx image.
    ```yml
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx-health-pod
      labels:
        app: health-web
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
          ports:
            - containerPort: 80
          volumeMounts:
            - name: config-volume
              mountPath: /etc/nginx/nginx.conf
              subPath: nginx.conf
      volumes:
        - name: config-volume
          configMap:
            name: nginx-health-config
    ```

3. Later i test that the mounted config works: kubectl exec <pod> -- curl -s http://localhost/health
    - `kubectl exec nginx-health-pod -- curl -s http://localhost/health`


#### Verify: Does the /health endpoint respond?
* **YES!** the /health endpoint respond = **"healthy"**

## TASK-4
1. I use kubectl create secret generic db-credentials with --from-literal to store DB_USER=admin and DB_PASSWORD=s3cureP@ssw0rd
2. I inspect with kubectl get secret db-credentials -o yaml — the values are base64-encoded.
    - `kubectl get secret db-credentials -o yaml`
        ```bash
        apiVersion: v1
        data:
          DB_PASSWORD: czNjdXJlUEBzc3cwcmQ=
          DB_USER: YWRtaW4=
        kind: Secret
        metadata:
          creationTimestamp: "2026-09-29T17:27:02Z"
          name: db-credentials
          namespace: default
          resourceVersion: "43818"
          uid: 9edd3b8a-afbc-4631-bdf5-29348246528a
        type: Opaque
        ```

3. I Decode a value: echo '<basevalue>' | base64 --decode
    ```bash
    echo "czNjdXJlUEBzc3cwcmQ" | base64  --decode
    s3cureP@ssw0rd
    ```

* base64 is encoding, not encryption. Anyone with cluster access can decode Secrets. The real advantages are RBAC separation, tmpfs storage on nodes, and optional encryption at rest.

#### Verify: Can you decode the password back to plaintext?
* **YES!** i decoded the password to the plaintext **"s3cureP@ssw0rd"**.

## TASK-5 
1. I write a Pod manifest that injects DB_USER as an environment variable using secretKeyRef.
    ```yml
    apiVersion: v1
    kind: Pod
    metadata:
      name: my-pod
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        env:
          - name: DB_USER
            valueFrom:
              secretKeyRef:
                name: db-credentials
                key: DB_USER
        volumeMounts:
           - name: secret-volume
             mountPath: /etc/db-credentials
             readOnly: true

      volumes:
        - name: secret-volume
          secret:
            secretName: db-credentials
    ```

2. In the same Pod, mount the entire db-credentials Secret as a volume at /etc/db-credentials with readOnly: true
3. Verify: each Secret key becomes a file, and the content is the decoded plaintext value.
    - **"DB_USER=admin"**


#### Verify: Are the mounted file values plaintext or base64?
* The mounted file is base64 value

## TASK-6
1. I create a ConfigMap live-config with a key `message=hello`
2. I write a Pod that mounts this ConfigMap as a volume and reads the file in a loop every 5 seconds.
3. Update the ConfigMap: 
    - `kubectl patch configmap live-config --type merge -p '{"data":{"message":"world"}}'`
        ```bash
        Current Message: hello
        Current Message: hello
        Current Message: hello
        Current Message: hello
        Current Message: hello
        Current Message: hello
        Current Message: hello
        Current Message: hello
        Current Message: hello
        Current Message: hello
        Current Message: hello
        ```
4. Then i wait for 30-60 seconds — the volume-mounted value updates automatically.
5. Environment variables from earlier tasks do NOT update — they are set at pod startup only

#### Verify: Did the volume-mounted value change without a pod restart?
*  **YES!** the volume-mounted value changes without a pod restart.

## TASK-7
1. Delete all pods, ConfigMaps, and Secrets you created.


#### What ConfigMaps and Secrets are and when to use each
* **ConfgMaps :** stores value as plaintext it didn't encrypt, encode or decode data.
* **Secrets :** it stores data as a **base64** value encoded and when we use it, it will be decoded in plaintext.

#### The difference between environment variables and volume mounts
* **Environment variables :-** used to fetch data or value from configMaps and secrets or from the same file.
    - Values are injected into the container's OS environment at startup.
    - Simple configuration flags, port numbers, or quick application parameters.

* **Volume mounts :-** a virtual directory used to save data inside the container, is then pod stopped or deleted the data is secured in volume and can be attached to another pod.
    -  The resource is mounted as a virtual directory inside the container. Each key becomes a file, and the value becomes the file content.
    - Large configuration files (like nginx.conf), certificates, or values that change over time.

#### Why base64 is encoding, not encryption
* **Encoding (Base64):** Scrambles data only to handle special characters safely. It requires no key and can be instantly decoded by anyone using base64 --decode.
* **Encryption:** Uses a secret cryptographic key to protect data. It remains completely unreadable unless you have the correct key to unlock it.

#### How ConfigMap updates propagate to volumes but not env vars
* **Environment Variables:** Injected only at startup. Linux cannot change a running process's environment, so updates require a Pod restart.
* **Volume Mounts:** Mounted as files via symbolic links. The kubelet dynamically updates these files on disk, letting the app read new data without restarting.
