while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 20; done

# kustomize build 'example' | kubectl delete -f -
