kubectl create secret generic ceph-secret --from-file=kube-key.txt --namespace=kube-system --type=kubernetes.io/rbd
kubectl create secret generic ceph-admin-secret --from-file=kube-admin-key.txt --namespace=kube-system --type=kubernetes.io/rbd


