#!/bin/bash
gcloud config set compute/region asia-south1
gcloud config set compute/zone asia-south1-a

gcloud compute networks subnets create kubernetes --network kubernetes-cluster --range 10.240.0.0/24
gcloud compute firewall-rules create kubernetes-cluster-allow-internal --allow tcp,udp,icmp --network kubernetes-cluster --source-ranges 0.0.0.0/0
gcloud compute addresses create kubernetes-controller --region $(gcloud config get-value compute/region)


PUBLIC_IP=$(gcloud compute addresses describe kubernetes-controller --region $(gcloud config get-value compute/region) --format 'value(address)')
gcloud compute instances create controller \
    --async \
    --boot-disk-size=200GB \
    --can-ip-forward \
    --image-family=ubuntu-1804-lts \
    --image-project=ubuntu-os-cloud \
    --machine-type=n1-standard-1 \
    --private-network-ip=10.240.0.10 \
    --scopes=compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet=kubernetes \
    --address=$PUBLIC_IP

for i in 0 1; do \
  gcloud compute instances create worker-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-1804-lts \
    --image-project ubuntu-os-cloud \
    --machine-type n1-standard-1 \
    --private-network-ip 10.240.0.2${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes; \
done

for i in controller worker-0 worker-1; do \
  printf "copying to ${i}--------------------"
  gcloud compute scp daemon.json kubernetes.list k8s.conf temp.sh ${i}:/tmp/ ; \
done

echo "###########################################  controller setup  ###########################################"; \
gcloud compute ssh controller -- 'sudo chmod +x /tmp/temp.sh && cd /tmp && sudo ./temp.sh \'; \
echo "###########################################  controller setup completed  ###########################################"; \
echo "###########################################  worker-0 setup  ###########################################"; \
gcloud compute ssh worker-0 -- 'sudo chmod +x /tmp/temp.sh && cd /tmp && sudo ./temp.sh \'; \
echo "###########################################  worker-0 setup completed  ###########################################"; \
echo "###########################################  worker-1 setup  ###########################################"; \
gcloud compute ssh worker-1 -- 'sudo chmod +x /tmp/temp.sh && cd /tmp && sudo ./temp.sh \' ; \
echo "###########################################  worker-1 setup completed  ###########################################" ; \