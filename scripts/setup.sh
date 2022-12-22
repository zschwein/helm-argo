#/bin/bash

dependency_check() {
  if command -v $(which minikube) > /dev/null 2>&1 ; then
    MINIKUBE=$(which minikube)
    printf "minikube found"
  else
    printf "need to install minikube"
    exit 1
  fi

}


minikube delete
minikube start --cpus=4 --memory=5g
helm install argo-cd ../chart
sleep 120
kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo -e "\n"
helm install argo-cd-apps ../apps/
sleep 30
kubectl port-forward svc/argo-cd-argocd-server 8080:443