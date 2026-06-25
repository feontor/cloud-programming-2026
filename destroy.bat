@echo off
echo Destroying AWS infrastructure...
terraform destroy
echo All resources destroyed.
pause