# DevOps Practice Assingment

Implementing Kube, ArgoCD and Docker with ArgoCD Canary Release

## Setting up

### **Minikube and KubeCTL**
Install Kube on the machine. I am using MiniKube

Make sure you have `chocolatey` installed on your system and run the below command to start installation of minikube and kubectl.
> curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
> sudo install minikube-linux-amd64 /usr/local/bin/minikube
> curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
> sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
> kubectl version
> minikube version

Install docker with the script at the script/dockerinstall.sh

Once the installation is completed, start the kube cluster on your computer with the below command.
Note: `minikube` uses a VM Manager, make sure you have one installed for it to create a VM.
> minikube start --addons=dns=coredns

After the minikube has the VM created for you run the below command to verify. It wil display you all of the available nodes.
> kubectl get nodes

Run the below two commands to check if the setup is working correctly. Below commands will expose and create a minikube service and expose it to be accessed.
> kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
> kubectl expose deployment hello-minikube --type=NodePort --port=8080

Run the below command to get the URL for the above service and open the given address.
> minikube service hello-minikube --url

### **Installing Argo CD**

Install argocd with the below command.
> kubectl create namespace argocd
> kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Run the below command to patch it
> kubectl patch svc argocd-server -n argocd --type='json' -p='[{"op": "replace", "path": "/spec/type", "value": "LoadBalancer"}]'

Install ArgoCD CLI or form here <https://github.com/argoproj/argo-cd/releases/latest>.
> choco install argocd-cli

Get the admin password with: <!-- uZbCYjOLH6WzT-3Z -->
> argocd admin initial-password -n argocd

Run the below command to run ArgoCD
> kubectl port-forward svc/argocd-server -n argocd 8080:443

login into ArgoCD using the CLI. Default is below. Use the `admin` default user and password you from the command in the cli before.
> argocd login 127.0.0.1:8080

Once inside the ArgoCD UI, create the app and traverse around as you may.

Get the kube address from the below command
> kubectl config view

### Get Commands will be handy!!

> kubectl get pod
> kubectl get svc

You can also get the services inside a namespace with below
> kubectl get svc -n argocd
> kubectl get svc -n myapp
