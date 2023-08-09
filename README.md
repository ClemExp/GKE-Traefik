# GKE cluster provisioning (Traefik & Terraform)

The objective of this project is to provision a GKE (Google Kubernetes Engine) cluster, via terraform, to host containerized web applications and be securly accessed (full end-end) via TLS.
Traefik will be the ingress controller and we will monitor the cluster operations via Grafana & Prometheus.
Full architecture will involve the use of the load balancers, firewalls, SQL DBaaS etc. 

This project details the steps from project creation through to deployment. In each subfolder there are further README files to describe the specifics of the setup..

## Table of Contents

- [Base Architecture](#base-architecture)
  - [Steps](#steps)
  - [Additional Information](#additional-information)
- [Metrics and Monitoring Setup](#metrics-and-monitoring-setup)
  - [Changes to Exercise 15](#changes-to-exercise-15)
- [Conclusion](#conclusion)

## Base Architecture

### Summary

the base architecture we have created a LAMP architecture directly in GCP.

### Key architecture decisions

Application is secured with TLS via a Google managed certificate. In order to put this in place we used an external DNS provider (google domains) and integrated this with Google’s managed certificate through a HTTPS load balancer.

Traefik proxy is a modern reverse proxy and ingress controller that integrates with our infrastructure components and allows us to deploy applications fronted by traefik ingress service.

The HTTPS load balancer is used to balance requests amongst our traefik instances. Here we are specifically using a HTTPS load balancer, offloading the TLS on the load balancer level. We have load balancer health checks in place, to ensure our traefik instance is up and running and awaiting application deployment events.

We have setup the external DNS lookup to the IP of the load balancer, creating Google static IPs, to ensure the DNS lookup is stable.

Our application is deployed via helm via ClusterIP service, only being exposed to the outside world via traefik ingress controller, thus providing on centralized point for application access

## Architecture setup

1. **Create new GCP project**

   Recommend to create a new GCP project for hosting the GKE cluster. This can be done via the GCP console, or gcloud utility.

2. **Configure infrastructure variables for cluster**



3. **Create GKE Cluster via Terraform - Multi-Node**

   Use Terraform configuration to create a new cluster with required node architecture. So as not to impact test evaluations, we are integrating platform services outside GKE (DBaaS), but nevertheless we have essential monitoring (Grafan / Prometheus) within the cluster, so we need several nodes for application hosting. 
   For cluster setup we are using the standard cluster mode, where we have control over managing the infrastructure nodes ourselves, rather than using the GKE auto-pilot.
   We are also using the terraform helm provider to deploy our key applications (traefik, cert-manager etc).
   More detail on terraform setup and execution can be found in the terraform sub-folder.

4. **Configure DNS for cluster**

   Change to the directory where your Terraform scripts are located..


5. **Create Namespace for Traefik**

Run the following command to create a namespace named `traefik` in the new cluster:

