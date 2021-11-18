Essentials before you begin.
Create a GCP trial account.
Configure gcloud cli so that you are authenticated. 
Note: these instructions and scripts are designed bearing a linux env in mind where gcloud cli is configured.

Step1: 

    Run ./setup.sh from the console where gcp cli has been initialized.

Step2: 

    once intialization is completed, login to controller node, using the command:
    gcloud compute ssh controller
    run line number : 79 to 90 from the kubeadm_setup file. Once init has been run you will be given a join command, save it somewhere

Step3:

    login to worker-0 and worker-1 using the command: 
    gcloud compute ssh worker-n
    use the above saved join command and issue it on the worker nodes.
    Note: Ensure u append sudo, or are root user on worker nodes before issuing the join command.



Check in controller node (by ssh as mentioned above in step2) the status of the cluster, by using the kubectl commands

Cleanup:

    Once the usage has been completed: Issue: ./cleanup.sh to clean the gcp setup done.