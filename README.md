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

###### Deploy commands for each stage
```
# stage 1: state bucket
terraform apply -target=module.state_bucket
```
```
# import it into tf state
terraform import module.state_bucket.aws_s3_bucket.terraform_state_bucket wilsonwkj-project-srehomework-tfstate-lab
```
```
# stage 2: vpc network
terraform apply -target=module.vpc
```
```
# stage 3: ecr
terraform apply -target=module.ecr
```
```
# stage 4: eks
terraform apply -target=module.eks
aws eks update-kubeconfig --name sre-homework-eks-cluster --region ap-southeast-1 --profi
le wilsonwkj-aws-lab
```
graph TD
  A[IAM Roles] --> B[EKS Cluster]
  B --> C[Node Group]
  A --> D[Instance Profile]
  D --> C
```
# stage 4: 
terraform apply -target=module.alb
```

###### Troubleshooting and docs
https://ithelp.ithome.com.tw/m/articles/10293460
https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
