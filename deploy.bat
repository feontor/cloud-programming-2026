@echo off
echo Deploying AWS infrastructure...
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
echo Done! Check the outputs above for your CloudFront URL.
pause