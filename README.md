# EKS on Terraform (managed nodes + Pod Identity)

## Layout
| File | Purpose |
|---|---|
| versions.tf | Terraform/provider pins, provider config, (commented) S3 backend |
| variables.tf | All inputs |
| vpc.tf | Dedicated VPC, 3 AZs, private + public subnets, NAT |
| eks.tf | Cluster role, control plane, access entries, add-ons |
| nodes.tf | Node role, hardened launch template, managed node group |
| pod-identity.tf | IAM roles for EBS CSI and LB Controller via Pod Identity |
| outputs.tf | Endpoint, CA, role ARNs, kubeconfig command |

## Before you apply
1. Download the official LB Controller policy (kept out of the repo so you always pull the current one):
   ```bash
   curl -o policies/aws-lb-controller-policy.json \
     https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
   ```
2. Check `k8s_version` against currently supported EKS versions.
3. Optionally set `admin_principal_arns` and restrict `endpoint_public_access_cidrs` in a `terraform.tfvars`.

## Apply
```bash
terraform init
terraform plan -out tfplan
terraform apply tfplan
$(terraform output -raw kubeconfig_command)
kubectl get nodes
```

## Install the AWS Load Balancer Controller
Pod Identity binds the IAM role to the `aws-load-balancer-controller` service account in `kube-system`.
Node IMDS hop limit is 1, so pass region and VPC ID explicitly:
```bash
helm repo add eks https://aws.github.io/eks-charts && helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$(terraform output -raw cluster_name) \
  --set region=us-east-1 \
  --set vpcId=$(terraform output -raw vpc_id) \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller
```

## Verify EBS CSI
```bash
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
```

## Cost note
NAT gateway + 3x t3.medium + the EKS control plane bill hourly. Run `terraform destroy` when done.
