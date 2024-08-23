

# install ceph
# git clone https://github.com/kubernetes-incubator/external-storage.git
# cd external-storage/ceph/rbd/deploy/
# NAMESPACE=kube-system
# sed -r -i "s/namespace: [^ ]+/namespace: $NAMESPACE/g" ./rbac/clusterrolebinding.yaml ./rbac/rolebinding.yaml
# kubectl -n $NAMESPACE apply -f ./rbac
# 
#
#
# cat <<EOF >./storage-class.yaml
#kind: StorageClass
#apiVersion: storage.k8s.io/v1
#metadata:
#  name: ceph-rbd
#provisioner: ceph.com/rbd
#parameters:
#  monitors: 10.73.88.52:6789, 10.73.88.53:6789, 10.73.88.54:6789
#  pool: kube
#  adminId: admin
#  adminSecretNamespace: kube-system
#  adminSecretName: ceph-admin-secret
#  userId: kube
#  userSecretNamespace: kube-system
#  userSecretName: ceph-secret
#  imageFormat: "2"
#  imageFeatures: layering
#EOF
#
# kubectl apply -f storage-class.yaml
# kubectl get sc
#
#
#
#cat <<EOF >./claim.yaml
#kind: PersistentVolumeClaim
#apiVersion: v1
#metadata:
#  name: claim1
#spec:
#  accessModes:
#    - ReadWriteOnce
#  storageClassName: ceph-rbd
#  resources:
#    requests:
#      storage: 1Gi
#EOF
#
#
# kubectl apply -f claim.yaml
# kubectl get pvc
# cat <<EOF >./create-file-pod.yaml
#kind: Pod
#apiVersion: v1
#metadata:
#  name: create-file-pod
#spec:
#  containers:
#  - name: test-pod
#    image: gcr.io/google_containers/busybox:1.24
#    command:
#    - "/bin/sh"
#    args:
#    - "-c"
#    - "echo Hello world! > /mnt/test.txt && exit 0 || exit 1"
#    volumeMounts:
#    - name: pvc
#      mountPath: "/mnt"
#  restartPolicy: "Never"
#  volumes:
#  - name: pvc
#    persistentVolumeClaim:
#      claimName: claim1
#EOF
#
#
# kubectl apply -f create-file-pod.yaml
# kubectl get pods -w
#
# 
#
# cat <<EOF >./test-pod.yaml
#kind: Pod
#apiVersion: v1
#metadata:
#  name: test-pod
#spec:
#  containers:
#  - name: test-pod
#    image: gcr.io/google_containers/busybox:1.24
#    command:
#    - "/bin/sh"
#    args:
#    - "-c"
#    - "sleep 600"
#    volumeMounts:
#    - name: pvc
#      mountPath: "/mnt/test"
#  restartPolicy: "Never"
#  volumes:
#  - name: pvc
#    persistentVolumeClaim:
#      claimName: claim1
#EOF
#
#
# kubectl exec test-pod -ti sh
# cat /mnt/test/test.txt
# Helo world!
#
#
#
#
#
#
#
#
#
#


