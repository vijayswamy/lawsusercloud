echo "#################### disbaling swap and handling bridge setting ####################"
swapoff -a; \
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab; \
sudo modprobe br_netfilter; \
cp /tmp/k8s.conf /etc/sysctl.d/k8s.conf; \
sysctl --system; \
echo "===================================================================================="
printf "\n\n\n"
echo "#################### update, add dependencies, add docker repo and install docker ####################"
apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common; \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -; \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"; \
#apt-get update && apt-get install -y docker-ce=5:19.03.12~3-0~ubuntu-bionic docker-ce-cli=5:19.03.12~3-0~ubuntu-bionic; \
apt-get update && apt-get install -y containerd.io docker-ce docker-ce-cli; \
#apt-mark hold containerd.io docker-ce docker-ce-cli; \
cp /tmp/daemon.json /etc/docker/daemon.json; \
mkdir -p /etc/systemd/system/docker.service.d; \
systemctl daemon-reload; \
systemctl restart docker; \
systemctl enable docker; \
echo "===================================================================================="
printf "\n\n\n"
echo "#################### update, add dependencies, add kubeadm repo and install kubeadm ####################"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -; \
cp /tmp/kubernetes.list /etc/apt/sources.list.d/kubernetes.list; \
apt-get update; \
#apt-get install -y kubelet=1.18.6-00 kubeadm=1.18.6-00 kubectl=1.18.6-00; \
apt-get install -y kubelet=1.20.1-00 kubeadm=1.20.1-00 kubectl=1.20.1-00; \
apt-mark hold kubelet kubeadm kubectl; \
echo "===================================================================================="
printf "\n\n\n"