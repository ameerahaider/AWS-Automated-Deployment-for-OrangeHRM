# **AWS-Automated-Deployment-for-OrangeHRM**

Deploy OrangeHRM seamlessly on AWS EC2 instances with minimal manual intervention using our automated pipelines.

## **Introduction**

OrangeHRM is a widely-used Human Resource Management (HRM) system, offering a range of HR functionalities. This repository simplifies the process of setting up OrangeHRM on AWS, providing Infrastructure as Code (IaC) and automated pipelines for efficient deployment.

## **Infrastructure Overview**

The infrastructure provisioning adheres to IaC principles with:

- **VPC Configuration:** An orchestrated VPC with two public subnets for the Application Load Balancer (ALB) and two private subnets for EC2 instances and the database.
  
- **Database:** A secure MySQL database operating within a private subnet.

- **Security Measures:** Employing an assume role mechanism to access AWS resources, negating the need for storing access keys in the repository.

## **Pipelines**

We've divided the deployment process into two main pipelines:

### 1. **Infrastructure Pipeline**

- **Branch:** `infra`
  
- **Objective:** To set up initial infrastructure on AWS.

- **Stages:** 
  1. VPC and subnets configuration.
  2. MySQL database setup.
  3. Implementation of the assume role for secure access.

### 2. **Deployment Pipeline**

- **Branch:** `code`
  
- **Objective:** For code deployment and application setup on EC2.

- **Stages:** 
  1. Fetch configurations from Parameter Store.
  2. Retrieve secrets via AWS Secrets Manager.
  3. Deploy OrangeHRM onto EC2 instances.

## **Pre-Deployment Setup**

Before running the pipelines:

1. Create an S3 bucket "my-terraform-state-bucket-cicd" for Terraform state.
2. Set up an ECR repository "orangehrm" for Docker images.
3. Integrate GitLab with AWS via an Identity Provider.
4. Set up an AWS Role and Policy for the pipeline.
5. Push to the `infra` branch for infrastructure setup.
6. Trigger the `deploy` branch for OrangeHRM deployment.

## **Workflow**

1. Push to `infra` to initiate infrastructure pipeline.
2. Post infrastructure setup, push to `deploy` for deployment pipeline.
3. Once done, OrangeHRM is ready on EC2 instances. Follow OrangeHRM setup instructions to finalize the installation.
