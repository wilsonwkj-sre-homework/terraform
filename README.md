# terraform
### First time creation manual setup
###### tfstate s3 bucket in each environment:
```
# create bucket
aws s3api create-bucket \
  --bucket wilsonwkj-project-srehomework-tfstate-lab \
  --region ap-southeast-1 \
  --create-bucket-configuration LocationConstraint=ap-southeast-1 \
  --profile wilsonwkj-aws-<ENV>

# import it into tf state
terraform import module.state_bucket.aws_s3_bucket.terraform_state_bucket wilsonwkj-project-srehomework-tfstate-lab

```
###### state lock DynamoDB table
```
aws dynamodb create-table \
  --table-name terraform-locks-lab \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-southeast-1 \
  --profile wilsonwkj-aws-<ENV>
  ```