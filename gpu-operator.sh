helm repo add nvidia https://nvidia.github.io/gpu-operator
helm repo update
helm install --generate-name      nvidia/gpu-operator
#kubectl run gpu-test      --rm -t -i      --restart=Never      --image=nvcr.io/nvidia/cuda:10.1-base-ubuntu18.04 nvidia-smi
kubectl describe nodes  |  tr -d '\000' | sed -n -e '/^Name/,/Roles/p' -e '/^Capacity/,/Allocatable/p' -e '/^Allocated resources/,/Events/p'  | grep -e Name  -e  nvidia.com  | perl -pe 's/\n//'  |  perl -pe 's/Name:/\n/g' | sed 's/nvidia.com\/gpu:\?//g'  | sed '1s/^/Node Available(GPUs)  Used(GPUs)/' | sed 's/$/ 0 0 0/'  | awk '{print $1, $2, $3}'  | column -t
kubectl label nodes node-7 gpumem=24gb
kubectl cluster-info
kubectl get nodes -A

