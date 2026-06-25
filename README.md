# cloud-programming-2026 - Static Website Hosting on AWS
A static webpage hosted on AWS S3 and delivered via CloudFront CDN, provisioned using Terraform.

## Prerequisites
- An AWS account with an IAM user (Access Key + Secret Key)
- Terraform installed
- AWS CLI installed and configured

## Setup
1. Clone the repository
2. Run `aws configure` and enter your AWS credentials
3. Update `terraform.tfvars` with your own unique bucket name

## Deployment
Double click `deploy.bat` or run in terminal:
```bash
./deploy.bat
```
After completion, copy the `cloudfront_url` from the output and wait 5-15 minutes for propagation.

## Destroying Resources
Double click `destroy.bat` or run in terminal:
```bash
./destroy.bat
```

## File Structure
provider.tf – tells terraform which cloud provider to use and how to connect to it.
variables.tf – defines variables that can be reused throughout the project.
terraform.tfvars – stores the actual values for those variables.
main.tf – the actual infrastructure (S3 bucket, CloudFront).
outputs.tf – displays useful information, like a URL, after deployment.
website folder – contains index.html and .jpg file for the actual webpage.
deploy.bat – automates the deployment process
destroy.bat – automates the teardown process
