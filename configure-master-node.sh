#!/bin/bash -ex

master_node=172.16.8.10
pod_network_cidr=192.168.84.0/16

initialize_master_node ()
{
sudo systemctl enable kubelet
sudo kubeadm config images pull
sudo kubeadm init --apiserver-advertise-address=$master_node --pod-network-cidr=$pod_network_cidr --ignore-preflight-errors=NumCPU
}

create_join_command ()
{
kubeadm token create --print-join-command | tee /vagrant/join_command.sh
chmod +x /vagrant/join_command.sh
}

configure_kubectl () 
{
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

##For vagrant user
mkdir -p /home/vagrant/.kube
sudo cp -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown 900:900 /home/vagrant/.kube/config
}

install_network_cni ()
{
#kubectl apply -f /vagrant/kube-flannel.yml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml
kubectl create -f /vagrant/calico-custom-resources.yaml
}

install_helm ()
{
	curl -fsSLO https://get.helm.sh/helm-v2.17.0-linux-amd64.tar.gz
	tar zxf helm-v2.17.0-linux-amd64.tar.gz
	cp linux-amd64/{helm,tiller} /usr/local/bin

	kubectl create serviceaccount --namespace kube-system tiller
	kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
	helm init --service-account tiller
}


initialize_master_node
configure_kubectl
install_network_cni
create_join_command
