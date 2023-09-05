# OrangeHRM Deployment on EC2 Instances

This repository contains code and configuration for automating the deployment of OrangeHRM on EC2 instances using AWS services. The deployment process has been streamlined through minimizing manual intervention.

## Infrastructure Overview

The infrastructure provisioning adheres to Infrastructure as Code (IaC) principles and employs two dedicated pipelines, ensuring consistent and replicable deployments. Key components of the infrastructure setup include:

- **VPC Configuration:** A Virtual Private Cloud (VPC) is orchestrated with three subnets: two public subnets designated for the Application Load Balancer (ALB), and one private subnet allocated for EC2 instances and one private subnet allocated for the database.

- **Database:** The backend database utilizes MySQL, operating within a private subnet to bolster security measures.

- **Security Measures:** No access keys or secret access keys are stored within the repository. Rather, an assume role mechanism is implemented to grant secure access to AWS resources.

## Pipelines

The deployment procedure encompasses two pipelines:

### 1. Infrastructure Pipeline

- **Branch:** `infra`
- **Objective:** This pipeline orchestrates the initial infrastructure setup on AWS.
- **Stages:**
  1. Configures the VPC alongside subnets and associated configurations.
  2. Establishes the MySQL database infrastructure.
  3. Institutes an assume role mechanism for safeguarded access.

### 2. Deployment Pipeline

- **Branch:** `code`
- **Objective:** This pipeline governs code deployment and application setup.
- **Stages:**
  1. Retrieves essential configuration parameters from the Parameter Store (e.g., host IP, usernames, passwords, EC2 IPs, PEM key, DNS name).
  2. Acquires sensitive data and secrets via AWS Secrets Manager.
  3. Deploys the OrangeHRM codebase onto the designated EC2 instances.

## Pre-Deployment Setup

Prior to initiating the pipelines, please perform the following preliminary tasks:

1. Create an S3 bucket named "my-terraform-state-bucket-cicd" for storing Terraform state.
2. Set up a publicly accessible Elastic Container Registry (ECR) repository named "orangehrm" to house Docker images.
3. Configure an Identity Provider within GitLab for seamless integration with AWS services.
4. Establish an AWS Role and associated Policy for assuming roles during pipeline execution.
5. Push the `infra` branch to initiate the infrastructure setup process.
6. Deploy the OrangeHRM application by triggering the `deploy` branch pipeline.

## Workflow

1. Push changes to the `infra` branch to trigger the infrastructure pipeline.
2. The infrastructure pipeline deploys the requisite resources.
3. Push changes to the `deploy` branch to trigger the deployment pipeline.
4. The deployment pipeline extracts configurations from the Parameter Store and retrieves secrets from the Secrets Manager.
5. The OrangeHRM application is successfully deployed onto the designated EC2 instances.
6. Perform the necessary manual steps to set up OrangeHRM.
