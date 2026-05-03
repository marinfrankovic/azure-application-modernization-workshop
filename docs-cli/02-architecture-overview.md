# 02 - Architecture Overview

## Objective

Understand the starting architecture, target track options, and responsibility split between initial provisioning and attendee work.

## Starting Architecture

The source environment represents the current state of the application:

- eShopOnWeb runs as a non-containerized .NET application on a Linux VM.
- The VM is deployed into a source VNet.
- The source app remains available during migration for comparison and rollback.

## Destination Foundation

The destination environment starts intentionally empty except for networking:

- A destination VNet is created for the selected track.
- Track-specific subnets are created to guide placement decisions.
- No AKS cluster, registry, gateway, messaging service, monitoring resource, Key Vault, or Defender configuration is created for you.

## Target Track Architectures

Track A creates a simple AKS destination. You containerize eShopOnWeb, create AKS, deploy the workload, and expose it through a Kubernetes service or ingress.

Track B creates an enterprise AKS destination. You add ACR for image management, APIM for controlled routing, Service Bus for asynchronous integration, and Application Insights for telemetry.

Track C creates a regulated AKS destination. You design private or restricted AKS access, use Key Vault for secrets, enable Defender for Cloud controls, and validate network isolation.

## Connectivity

Source and destination VNets may be peered by the foundation script so you can test transition patterns. Peering does not mean the final architecture must depend on the source VM. Treat it as temporary migration connectivity.

## Expected Outcome

You can explain the source VM, destination VNet foundation, and the Azure services you must create for your selected track.
