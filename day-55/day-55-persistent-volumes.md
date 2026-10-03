# Day 55 – Persistent Volumes (PV) and Persistent Volume Claims (PVC)
## TASK-1
1. I write a Pod manifest that uses an `emptyDir:` volume and writes a timestamped message to **/data/message.txt**
2. Apply it, verify the data exists with kubectl exec
    - **Applying it:-** `kubectl apply -f volume-pod.yml`
    - **Verifying data:-** `kubectl exec volume-pod -- cat /data/message.txt`
3. I delete the Pod, recreate it, check the file again — the old message is gone.

#### Verify: Is the timestamp the same or different after recreation?
* The timestamp was different after recreation.

## TASK-2 
1. I write a PV manifest with `capacity: 1Gi`, `accessModes: ReadWriteOnce`, `persistentVolumeReclaimPolicy: Retain`, and `hostPath:` pointing to **/tmp/k8s-pv-data**
2. Apply it and check kubectl get pv — status should be Available
    - **Applying it:-** `kubectl apply -f persistent-volume.yml`
    - **Check status:-** `kubectl get pv`

#### Verify: What is the STATUS of the PV?
* I verifies the Status of 'Persistent Volume' is **Available**

## TASK-3
1. I write a PVC manifest requesting "500Mi" of storage with ReadWriteOnce access
2. I Apply it and check both kubectl get pvc and kubectl get pv
    - **Applying it:-** `kubectl apply -f persistent-volume-claim.yml`
    - **Check Volumes:-**
        - `kubectl get pv`
        - `kubectl get pvc`
3. Both are showing Bound — Kubernetes matched them by capacity and access mode

#### Verify: What does the VOLUME column in kubectl get pvc show?
* The Volume column shows **task-pv-volume** after running command `kubectl get pvc`

## TASK-4
1. I write a Pod manifest that mounts the PVC at `/data` using `persistentVolumeClaim.claimName`
2. I write data to `/data/message.txt`, then i delete and recreate the Pod
3. I check the file — it contains data from both Pods

#### Verify: Does the file contain data from both the first and second Pod?
* **YES!** this file contains data from both first and second pod

## TASK-5
1. I run `kubectl get storageclass` and `kubectl describe storageclass`
    ```bash
    kubectl get storageclass 
    NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
    standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  168m
    ```
    ```bash
    kubectl describe storageclass
    Name:            standard
    IsDefaultClass:  Yes
    Annotations:     kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"storage.k8s.io/v1","kind":"StorageClass","metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"},"name":"standard"},"provisioner":"rancher.io/local-path","reclaimPolicy":"Delete","volumeBindingMode":"WaitForFirstConsumer"}
    ,storageclass.kubernetes.io/is-default-class=true
    Provisioner:           rancher.io/local-path
    Parameters:            <none>
    AllowVolumeExpansion:  <unset>
    MountOptions:          <none>
    ReclaimPolicy:         Delete
    VolumeBindingMode:     WaitForFirstConsumer
    Events:                <none>
    ```
2. I note the provisioner, reclaim policy, and volume binding mode
    ```bash
    Provisioner:           rancher.io/local-path
    ReclaimPolicy:         Delete
    VolumeBindingMode:     WaitForFirstConsumer
    ```
3. With dynamic provisioning, developers only create PVCs — the StorageClass handles PV creation automatically

#### Verify: What is the default StorageClass in your cluster?
* The Default StorageClass in my cluster is **standard**

## TASK-6
1. I write a PVC manifest that includes `storageClassName:` standard (or your cluster's default)
2. Apply it — a PV appears automatically in `kubectl get pv`
    - **Applying it:-** `kubectl apply -f pvc.yml`
3. I use this PVC in a Pod named **"pvc-pod.yml"**, write data, verify it works

#### Verify: How many PVs exist now? Which was manual, which was dynamic?
* Now there's total persistent Volume exists.
    - **Manual PV :-**
        ```bash
        NAME                                       CAPACITY   ACCESS MODES   RECLAIMPOLICY   STATUS   CLAIM                STORAGECLASS   VOLUMEATTRIBUTESCLASS REASON   AGE
        task-pv-volume                             1Gi        RWO            Retain         Bound    default/pv-claim     manual         <unset>          99m
        ```
    - **Dynamic PV :-**
        ```bash
        NAME                                       CAPACITY   ACCESS MODES   RECLAIMPOLICY   STATUS   CLAIM                STORAGECLASS   VOLUMEATTRIBUTESCLASS REASON   AGE
        pvc-658dda32-8135-4f77-a9ca-2cd626214e7b   300Mi      RWO            Delete         Bound    default/pvc-volume   standard       <unset>          11m
        ```
## TASK-7
1. I delete all pods first
2. I delete PVCs — i check `kubectl get pv` to see what happened
3. The dynamic PV is gone (Delete reclaim policy). The manual PV shows Released (Retain policy).
4. I delete the remaining PV manually

#### Verify: Which PV was auto-deleted and which was retained? Why?
* Dynamic Persistent Volume was deleted automatically  because its policy was Delete, which automatically destroys the volume when the PVC is removed.
* Manual Persistent Volume was retained, because its policy was Retain, which safely preserves the volume and its data in a Released state for manual cleanup.

#### Why containers need persistent storage?
* Container Storage/data is temporary if container get deleted then the data will remove permanently to save the data from deleting with container we need persistent storage.

#### What PVs and PVCs are and how they relate
* **Persistent Volume (PV):** The actual storage resource in the cluster (e.g., a cloud disk, local SSD, or network file system). It is a cluster-level resource managed by administrators.
* **Persistent Volume Claim (PVC):** A request for storage by a user or a pod. It specifies requirements like size and access speed.

#### Static vs dynamic provisioning
* **Static Provisioning:** it is created manually by adminitrators and also deleted by adminitrators, Developers have to wait for admins to create storage, requires a yaml file
* **Dynamic Provisioning:** Storage is created automatically on-demand when a user requests it, Scales automatically without administrator intervention, Requires a defined StorageClass to act as a template.

#### Access modes and reclaim policies
* **Access modes:-**
    - **ReadWriteOnce (RWO):** read-write by a single node at a time. (Common for block storage like AWS EBS).
    - **ReadOnlyMany (ROX):** read-only by many nodes simultaneously.
    - **ReadWriteMany (RWX):** read-write by many nodes simultaneously. (Common for network file systems like NFS).
    - **ReadWriteOncePod (RWOP)**: read-write by a single pod in the entire cluster (introduced to strictly restrict multi-pod access on the same node).

* **Reclaim polices:-** 
    - **Retain:** The PV is kept intact but shifts to a Released state. No other PVC can claim it until an administrator manually cleans up the data and resets the volume.
    - **Delete:** The PV and the actual underlying physical infrastructure storage (e.g., the cloud disk) are automatically deleted immediately.