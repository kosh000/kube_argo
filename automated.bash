#!/bin/bash
set -x
## Bash Script to setup MiniKube and ArgoCD
##

## Installing MiniKube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

## Installing KubeCTL
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

## Verifying Installation
kubectl version
minikube version

## Start minikube
minikube start --addons=dns=coredns

sleep 30
## Verifying if it's working
kubectl get nodes

####
## ArgoCD
####

## Creating namespace and patching argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd --type='json' -p='[{"op": "replace", "path": "/spec/type", "value": "LoadBalancer"}]'

## Installing ArgoCD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

## Installing ArgoCD Rollout Plugin
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
chmod +x ./kubectl-argo-rollouts-linux-amd64
sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts

## creating rollouts
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

echo "it takes time for argocd to come up, 5 ish mins....."
sleep 350
## This will prompt you the password
## thisisnotapassword
argocd admin initial-password -n argocd 
read -rp "copy the above password for argocd and do change it later."

echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"
read -rp "Open another terminal and copy the above command to create a connection to ARGOCD"

read -rp "logging in ARGOCD, default user is admin and put the password you had copied before"
argocd login 127.0.0.1:8080
echo "########################################"
echo ""
read -rp "posting kube address"
kubectl config view
echo ""
echo "########################################"

## Creating stuff for ARGOCD and APP
kubectl create ns docuseal-ns

mkdir -p ~/argocd-testing
cd ~/argocd-testing || exit
git clone https://github.com/kosh000/kube_argo.git
cd kube_argo/  || exit

## Apply canary files
kubectl apply -f canary
echo "########################################"
echo ""
cat application-canary.yml
echo ""
echo "########################################"
echo "You should be able to access ArgoCD already, copy the above file and paste it in Create App's 'edit as yml' YML"
set +x
