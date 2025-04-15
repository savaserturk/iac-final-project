# CST8918 Final Project: Weather App with Azure AKS

This project demonstrates Infrastructure as Code (IaC) using Terraform to deploy a Remix Weather Application on Azure Kubernetes Service (AKS) with Azure Cache for Redis.

## Team Members

- Savas Erturk(GitHub: [your-github-username])
- Rohan James Scott(GitHub: [their-github-username])
- Khanh Duy Truong (GitHub: [their-github-username])
- Ben Yee GitHub: BenYee15

## Prerequisites

- Azure CLI
- Terraform
- kubectl
- Docker
- GitHub CLI (optional)

## Setup Instructions

1. Clone the repository
2. Install dependencies
3. Configure Azure credentials
4. Initialize Terraform
5. Apply infrastructure changes

## Infrastructure Components

- Azure Blob Storage (Terraform backend)
- Virtual Network with subnets
- AKS Clusters (test and prod)
- Azure Container Registry
- Azure Cache for Redis
- Kubernetes deployments

## GitHub Actions Workflows

- Static analysis on push
- Terraform plan and tflint on PR
- Automated deployments
- Docker image builds
