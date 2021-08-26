# Upgrad/IIIT-B capston

## Task 1
 
  - Create VPC. 
  ```
  terraform init
  terraform apply --auto-approve
  ```
  - To create cluster with EKS. Use the details from terraform output, `eksctl create cluster -f eksctl-config.yaml`
  - To delete the cluster, `eksctl delete cluster --region=us-east-1 --name=capstone-upgrad`
  - Install Helm, https://docs.aws.amazon.com/eks/latest/userguide/helm.html ,
  ```
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
  chmod 700 get_helm.sh
  ./get_helm.sh
  ```
  - Install AWS Load balancer, https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
  ```
  curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/install/iam_policy.json

  aws iam create-policy     --policy-name AWSLoadBalancerControllerIAMPolicy     --policy-document file://iam_policy.json

  eksctl create iamserviceaccount   --cluster=capstone-upgrad   --namespace=kube-system --name=aws-load-balancer-controller   --attach-policy-arn=arn:aws:iam::100887516960:policy/AWSLoadBalancerControllerIAMPolicy   --override-existing-serviceaccounts -r us-east-1 --approve

  kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"

  helm repo add eks https://aws.github.io/eks-charts

  helm repo update

  helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=capstone-upgrad \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-0c761c65b63a60471 \
  -n kube-system
  ```

  - Install metric server https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html,
  ```
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

  kubectl get deployment metrics-server -n kube-system
  ```
  - Install auto scaler
  ```
   cat << EOF > cluster-autoscaler-policy.json
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
  }
  EOF

  aws iam create-policy     --policy-name AmazonEKSClusterAutoscalerPolicy     --policy-document file://cluster-autoscaler-policy.json

  eksctl create iamserviceaccount \
  --cluster=capstone-upgrad \
  --namespace=kube-system \
  --name=cluster-autoscaler \
  --attach-policy-arn=arn:aws:iam::100887516960:policy/AmazonEKSClusterAutoscalerPolicy \
  --override-existing-serviceaccounts \
  --region=us-east-1 \
  --approve

  kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml

  kubectl annotate serviceaccount cluster-autoscaler \
  -n kube-system \
  eks.amazonaws.com/role-arn=arn:aws:iam::100887516960:role/AmazonEKSClusterAutoscalerRole

  kubectl patch deployment cluster-autoscaler \
  -n kube-system \
  -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'

  kubectl -n kube-system edit deployment.apps/cluster-autoscaler # see doc

  kubectl set image deployment cluster-autoscaler \
  -n kube-system \
  cluster-autoscaler=k8s.gcr.io/autoscaling/cluster-autoscaler:v1.21.0
  ```


## Task2

  - Create namespace, `kubectl create ns demo`
  - apply changes with `kubectl apply -f k8s-template/<filename>`

## Task3
  - apply changes with `kubectl apply -f task3/<filename>`
  - Get redis-cli pod name and exec into this pod
  - Follow steps in subtask3.
  - Restart redis-server-0 pod
  - Get value for key in above step.

## Task4
