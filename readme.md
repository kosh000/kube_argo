# DevOps Practice Assingment

Implementing Kube, ArgoCD and Docker with ArgoCD Canary Release

## Setting up

### **Minikube and KubeCTL**
Install Kube on the machine. I am using MiniKube

Run the below command to start installation of minikube and kubectl.
> curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
> sudo install minikube-linux-amd64 /usr/local/bin/minikube
> curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
> sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
> kubectl version
> minikube version

Install docker with the script at the script/dockerinstall.sh

Once the installation is completed, start the kube cluster on your computer with the below command. I have included coredn addon.
Note: `minikube` uses a VM Manager, make sure you have one installed for it to create a VM.
> minikube start --addons=dns=coredns

After the minikube has the VM created for you run the below command to verify. It wil display you all of the available nodes.
> kubectl get nodes

Run the below two commands to check if the setup is working correctly. Below commands will expose and create a minikube service and expose it to be accessed.
> kubectl create deployment minikube --image=kicbase/echo-server:1.0
> kubectl expose deployment minikube --type=NodePort --port=8080

Run the below command to get the URL for the above service and open the given address.
> minikube service minikube --url

### **Installing Argo CD**

Install argocd with the below command.
> kubectl create namespace argocd
> kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

ArgoCD Rollouts namespace downloaded
> kubectl create namespace argo-rollouts
> kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

Run the below command to patch it
> kubectl patch svc argocd-server -n argocd --type='json' -p='[{"op": "replace", "path": "/spec/type", "value": "LoadBalancer"}]'

Install ArgoCD CLI or form here <https://github.com/argoproj/argo-cd/releases/latest>.
> curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
> sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
> rm argocd-linux-amd64

Get the admin password with:
> argocd admin initial-password -n argocd

Run the below command to run ArgoCD
> kubectl port-forward svc/argocd-server -n argocd 8080:443

login into ArgoCD using the CLI. Default is below. Use the `admin` default user and password you from the command in the cli before.
> argocd login 127.0.0.1:8080

Once inside the ArgoCD UI, create the app and traverse around as you may.

Get the kube address from the below command
> kubectl config view

Create Namespace
> kubectl create ns docuseal-ns

Apply the files on Kube with the below command. PS: It also accpets folders. `cd` into the repo abd run the below command.
> kubectl apply -f canary

After all of this, create a application with the github repo and start it.
Get the application-canary.yml from github repo at root, Open ArgoCD > Create App > Edit as a YML and paste it there > Create app.

Install ArgoCD Rollouts Plugin.
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
chmod +x ./kubectl-argo-rollouts-linux-amd64
sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts

fetch rollouts with the below commands
kubectl get rs -n docuseal-ns
kubectl argo rollouts list rollouts -n docuseal-ns
kubectl argo rollouts get rollouts rollout-docuseal -n docuseal-ns

Promote the app once identifying that the rollout can be proceeded with.
kubectl argo rollouts promote rollout-docuseal -n docuseal-ns

### Get Commands will be handy

> kubectl get pod
> kubectl get svc
> kubectl get ns
> kubectl get rs

## Clean up

Open ArgoCD and Delete the application. As the app is deleted all of the services and pods should not longer exist.

Run the below command
> kubectl get ns

Delete the namespaces you had created. eg below
> kubectl delete ns docuseal-ns

Shutdown the kube using
> minikube stop

Delete the minikube data
> minikube delete
