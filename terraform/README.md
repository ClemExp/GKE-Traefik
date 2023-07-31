..
Main setup described in https://blog.yongweilun.me/auto-tls-with-cert-manager-and-traefik

I will walk through the demo on Google Cloud (GKE and Google DNS) with terraform, but the concept can be applied to other hosted Kubernetes or distribution

If you wish to follow along, make sure you have Google Cloud project created, and download service account with appropriate IAM roles assigned, to be used with terraform.

Also, create another service account for with DNS Administrator role assigned for DNS validation purposes.

Verify the installation, alternatively you can use console provided by cloud providers or Kubernetes dashbaord

```
kubectl get deploy,svc -n traefik
```

Clean up
All cloud resources cost money, make sure you clean up after experiment.

```
cd terraform/gke-traefik-cert-manager
terraform destroy
```
