for i in $(gcloud compute instances list --format='value(name)'); do \
  gcloud compute instances delete ${i} --delete-disks=all --quiet; \
done

gcloud compute addresses delete kubernetes-controller --quiet
gcloud compute firewall-rules delete kubernetes-cluster-allow-internal --quiet
gcloud compute networks subnets delete kubernetes --quiet