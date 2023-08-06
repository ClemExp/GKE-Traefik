# Cluster Access (Load balancers, certificates, DNS, ingress..)

After base cluster creation via terraform; load balancers, TLS security, certificates, DNS etc needs to be put in place.

This section details the setup involved.

## Creation of static IP

## Certificate management
Google certs:
- Provided by cloud provider
- Faster processing time
. Provisioning quite automatic
- Complexity reduced

Certificate management implications:
- Found out later issue with kubernetes secrets

## Ingress route creation - external cluster access


Wait for synch
Monitor with events, ing etc...
Wait for LB

## Load balancers
Auto creation via ingress
Front end configuration
Backend configuration
Healthchecks

## DNS configuration

## Traefik ingress routes
