# SRE Homework
Good morning team!
I have created an IAM user for you to take a look around my AWS lab environment!
```
Console sign-in link:
https://797181129561.signin.aws.amazon.com/console
account/pswd = Welcome-to-my-lab / Welcome!
```
DNS of the ALB fronted my EKS cluster is:
```
k8s-default-nginxapp-438ac42f3d-434409634.ap-southeast-1.elb.amazonaws.com
http://k8s-default-nginxapp-438ac42f3d-434409634.ap-southeast-1.elb.amazonaws.com/sre.txt
# Access this path to see the "Hello SRE!" greeting
```
The Nginx app Dockerfile is placed in another repo:
https://github.com/wilsonwkj-sre-homework/nginx-app

I've wrote CI/CD pipelines for both repos, the yaml can be found in /.github/workflows/

<br>

For question 5,
my solution for multi-environment CI/CD using Github can be define multi-stages of deployment, with the help of branches and conditions, we are able to bring different variables into our tasks in order to achieve multi-environment build(like tags) and deployment(targets, arns, endpoints):
```
deploy-staging:
    needs: build-and-test
    if: github.ref == 'refs/heads/develop'
    environment: staging
    ...
    - name: Configure AWS Credentials
    uses: aws-actions/configure-aws-credentials@v2
    with:
      aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID_STAGING }}
      aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY_STAGING }}
      aws-region: ${{ var.AWS_REGION_STAGING }}
      # This can brings us to the staging environment target
    ...
deploy-production:
    needs: build-and-test
    if: github.ref == 'refs/heads/master'
    environment: production
    ...
    - name: Deploy to Production
        run: |
          helm upgrade --install nginx-app-prod ./nginx-app-*.tgz \
            --namespace production --create-namespace \
            --set image.tag=latest
            # This can gave our artifact a corresponding suffix
    ...

```
For question 6,
my first thought will be using Helm --set flags during deployment, or which I coincidentally did with similar way in /nginx-app/values.yaml:24, substitute by /module/charts/charts.tf:50, both is a good and usual way to pass variables for service creation.

<br> 

# terraform deploy commands
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

# import it into tf state
terraform import module.state_bucket.aws_s3_bucket.terraform_state_bucket wilsonwkj-project-srehomework-tfstate-lab

# stage 2: vpc network
terraform apply -target=module.vpc

# stage 3: ecr
terraform apply -target=module.ecr

# stage 4: eks
terraform apply -target=module.eks

# stage 5: charts
cd /environments/common/            # for shared resource
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json
# Policies json that allow ingress pod(alb_controller) to create ALB

aws iam create-policy \
--policy-name AWSLoadBalancerControllerIAMPolicy \
--policy-document file://iam_policy.json \
--profile wilsonwkj-aws-lab
# Use AWS CLI to create policy

terraform import module.charts.aws_iam_policy.AWSLoadBalancerControllerIAMPolicy arn:aws:iam::797181129561:policy/AWSLoadBalancerControllerIAMPolicy
# Import the resource back to tfstate

terraform apply -target=module.charts
# Without the policy, alb list will be empty even if service pods starts up

# After alb security group was created in stage 5
# add a security group rule in eks_node_sg to allow inbound traffics from alb_sg (
# (else will get 504 bad gateway while accessing alb DNS)
terraform apply -target=module.eks
```

###### Reference and troubleshooting docs
https://ithelp.ithome.com.tw/m/articles/10293460
https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/node_groups.tf
