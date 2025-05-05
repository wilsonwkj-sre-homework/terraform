# terraform
### Manual setup
###### For the first time creation of tfstate s3 bucket in each environment, use:
```
aws s3api create-bucket \
  --bucket wilsonwkj-project-srehomework-tfstate-lab \
  --region ap-southeast-1 \
  --create-bucket-configuration LocationConstraint=ap-southeast-1 \
  --profile wilsonwkj-aws-<ENV>
```
