#!/bin/bash

set -e
snap install kustomize
git clone https://github.com/kubeflow/manifests.git
cd manifests
while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done

kubectl describe nodes  |  tr -d '\000' | sed -n -e '/^Name/,/Roles/p' -e '/^Capacity/,/Allocatable/p' -e '/^Allocated resources/,/Events/p'  | grep -e Name  -e  nvidia.com  | perl -pe 's/\n//'  |  perl -pe 's/Name:/\n/g' | sed 's/nvidia.com\/gpu:\?//g'  | sed '1s/^/Node Available(GPUs)  Used(GPUs)/' | sed 's/$/ 0 0 0/'  | awk '{print $1, $2, $3}'  | column -t


kubectl cluster-info 

# mysql create katib 
# create root@*
# mysql grant all privileges on katib to root
# change password from base64 to ''

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

#
#2024-02-03 19:31:04,432 | apps.common.form | INFO | Using provided value for 'tolerationGroup':
#2024-02-03 19:31:04,460 | apps.common.utils | INFO | Using config file: /etc/config/spawner_ui_config.yaml
#2024-02-03 19:31:04,460 | apps.common.form | WARNING | Didn't find any Toleration Group with key '' in the config
#2024-02-03 19:31:04,460 | apps.common.form | INFO | Using provided value for 'affinityConfig':
#2024-02-03 19:31:04,487 | apps.common.utils | INFO | Using config file: /etc/config/spawner_ui_config.yaml
#2024-02-03 19:31:04,487 | apps.common.form | WARNING | Didn't find any Affinity Config with key '' in the config
#2024-02-03 19:31:04,488 | apps.common.form | INFO | Using provided value for 'configurations': ['access-ml-pipeline']
#2024-02-03 19:31:04,488 | apps.common.form | INFO | Using provided value for 'shm': True
#2024-02-03 19:31:04,488 | apps.common.form | INFO | Using provided value for 'datavols': []
#2024-02-03 19:31:04,488 | apps.common.form | INFO | Using provided value for 'workspace': {'mount': '/home/jovyan', 'newPvc': {'metadata': {'name': 'test2-workspace'}, 'spec': {'accessModes': ['ReadWriteOnce'], 'resources': {'requests': {'storage': '5Gi'}}}}}
#2024-02-03 19:31:04,564 | root | INFO | Creating PVC: {'api_version': None,
# 'kind': None,
# 'metadata': {'annotations': None,
#              'cluster_name': None,
#              'creation_timestamp': None,
#              'deletion_grace_period_seconds': None,
#              'deletion_timestamp': None,
#              'finalizers': None,
#              'generate_name': None,
#              'generation': None,
#              'labels': None,
#              'managed_fields': None,
#              'name': 'test2-workspace',
#              'namespace': None,
#              'owner_references': None,
#              'resource_version': None,
#              'self_link': None,
#              'uid': None},
# 'spec': {'access_modes': ['ReadWriteOnce'],
#          'data_source': None,
#          'data_source_ref': None,
#          'resources': {'limits': None, 'requests': {'storage': '5Gi'}},
#          'selector': None,
#          'storage_class_name': None,
#          'volume_mode': None,
#          'volume_name': None},
# 'status': None}
#2024-02-03 19:31:04,600 | apps.default.routes.post | INFO | Creating Notebook: {'apiVersion': 'kubeflow.org/v1beta1', 'kind': 'Notebook', 'metadata': {'name': 'test2', 'namespace': 'kubeflow-user-example-com', 'labels': {'app': 'test2', 'access-ml-pipeline': 'true'}, 'annotations': {'notebooks.kubeflow.org/server-type': 'jupyter', 'notebooks.kubeflow.org/creator': 'user@example.com'}}, 'spec': {'template': {'spec': {'serviceAccountName': 'default-editor', 'containers': [{'name': 'test2', 'image': 'kubeflownotebookswg/jupyter-tensorflow-cuda-full:v1.8.0-rc.0', 'volumeMounts': [{'mountPath': '/dev/shm', 'name': 'dshm'}, {'name': 'test2-workspace', 'mountPath': '/home/jovyan'}], 'env': [], 'resources': {'requests': {'cpu': '0.5', 'memory': '1Gi'}, 'limits': {'cpu': '0.6', 'memory': '1.2Gi', 'nvidia.com/gpu': '1'}}, 'imagePullPolicy': 'IfNotPresent'}], 'volumes': [{'name': 'dshm', 'emptyDir': {'medium': 'Memory'}}, {'name': 'test2-workspace', 'persistentVolumeClaim': {'claimName': 'test2-workspace'}}], 'tolerations': []}}}}
#127.0.0.6 - - [03/Feb/2024:19:31:04 +0000] "POST /api/namespaces/kubeflow-user-example-com/notebooks HTTP/1.1" 200 99 "http://192.168.1.191/jupyter/new" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"
#2024-02-03 19:31:04,788 | kubeflow.kubeflow.crud_backend.authn | INFO | Handling request for user: user@example.com
#2024-02-03 19:31:04,788 | kubeflow.kubeflow.crud_backend.csrf | INFO | Skipping CSRF check for safe method: GET
#2024-02-03 19:31:04,901 | apps.common.utils | INFO | Using config file: /etc/config/spawner_ui_config.yaml
#2024-02-03 19:31:04,933 | apps.common.utils | INFO | Using config file: /etc/config/spawner_ui_config.yaml
#2024-02-03 19:31:04,933 | kubeflow.kubeflow.crud_backend.errors.handlers | ERROR | Caught and unhandled Exception!
#2024-02-03 19:31:04,933 | kubeflow.kubeflow.crud_backend.errors.handlers | ERROR | 'status'
#Traceback (most recent call last):
#  File "/usr/local/lib/python3.8/site-packages/flask/app.py", line 1484, in full_dispatch_request
#    rv = self.dispatch_request()
#  File "/usr/local/lib/python3.8/site-packages/flask/app.py", line 1469, in dispatch_request
#    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)
#  File "/src/apps/common/routes/get.py", line 55, in get_notebooks
#    contents = [utils.notebook_dict_from_k8s_obj(nb) for nb in notebooks]
#  File "/src/apps/common/routes/get.py", line 55, in <listcomp>
#    contents = [utils.notebook_dict_from_k8s_obj(nb) for nb in notebooks]
#  File "/src/apps/common/utils.py", line 141, in notebook_dict_from_k8s_obj
#    "status": status.process_status(notebook),
#  File "/src/apps/common/status.py", line 15, in process_status
#    status_phase, status_message = get_empty_status(notebook)
#  File "/src/apps/common/status.py", line 62, in get_empty_status
#    container_state = notebook["status"]["containerState"]
#KeyError: 'status'
#127.0.0.6 - - [03/Feb/2024:19:31:04 +0000] "GET /api/namespaces/kubeflow-user-example-com/notebooks HTTP/1.1" 500 98 "http://192.168.1.191/jupyter/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"
#
#




























