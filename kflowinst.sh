#!/bin/bash

set -e
snap install kustomize
git clone https://github.com/kubeflow/manifests.git
cd manifests
while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done

kubectl describe nodes  |  tr -d '\000' | sed -n -e '/^Name/,/Roles/p' -e '/^Capacity/,/Allocatable/p' -e '/^Allocated resources/,/Events/p'  | grep -e Name  -e  nvidia.com  | perl -pe 's/\n//'  |  perl -pe 's/Name:/\n/g' | sed 's/nvidia.com\/gpu:\?//g'  | sed '1s/^/Node Available(GPUs)  Used(GPUs)/' | sed 's/$/ 0 0 0/'  | awk '{print $1, $2, $3}'  | column -t

kubectl cluster-info 

#kubectl exec -it --namespace=tools postgres -- bash -c "psql -U postgres -d database_name -c "SELECT c_defaults  FROM user_info WHERE c_uid = 'testuser'""
#kubectl run mysql-client --image=mysql:5.7 -it --rm --restart=Never -- /bin/bash
#katib-mysql-74f9795f8b-n2kw5

MYSQLPOD=$(kubectl get pods -A | grep katib-mysql- | awk '{ print $2; }')
echo $MYSQLPOD
kubectl exec -it -n kubeflow $MYSQLPOD -- bash -c "mysqld --initialize-insecure;"
kubectl exec -it -n kubeflow $MYSQLPOD -- bash -c "mysql create katib;"
kubectl exec -it -n kubeflow $MYSQLPOD -- bash -c "create root@*;"
kubectl exec -it -n kubeflow $MYSQLPOD -- bash -c "mysql grant all privileges on katib to root;"

# mysql create katib 
# create root@*
# mysql grant all privileges on katib to root
# change password from base64 to ''


#  kubectl logs katib-db-manager-7bd66d5cff-tt6xp -n kubeflow
#  F0612 18:34:18.882984       1 main.go:104] Failed to open db connection: Invalid DB Name



# fix gpuvendor
# https://github.com/kubeflow/kubeflow/issues/7273
# kubectl edit cm jupyter-web-app-config-<suffix> -n kubeflow 
# vendor: ""
#**uncomment the following lines:**
#vendors:
#  - limitsKey: "nvidia.com/gpu"
#    uiName: "NVIDIA"
#  - limitsKey: "amd.com/gpu"
#    uiName: "AMD"

# kubectl rollout restart deployment jupyter-web-app-deployment-<suffix> -n kubeflow


# [403] Could not find CSRF cookie XSRF-TOKEN in the request. http://192.168.1.191/jupyter/api/namespaces/kubeflow-user-example-com/notebooks
# kubectl edit cm jupyter-web-app-parameters-42k97gcbmb  -n kubeflow
#  kubectl edit deployment jupyter-web-app-deployment  -n kubeflow 
# cookies = false


# [500] An error occured in the backend. http://192.168.1.191/jupyter/api/namespaces/kubeflow-user-example-com/notebooks

# https://github.com/kubeflow/kubeflow/issues/3770






# https://github.com/kubeflow/manifests/issues/2471
#Solved this problem by insert schema_version to mysql, sql: use metadb, insert into MLMDEnv values ("7"); ml-metadata 1.5.0 schema_version is 7 for me, detail schema_versio
