require "bundler/setup"
Bundler.require :default

AWS_PROFILE = "default"
# AWS_PROFILE = "projectname"

EKS_CLUSTER_NAME = "eks-test"

AWS_REGION = "eu-west-3"

EKSCTL_BIN_PATH = "/usr/local/bin/eksctl"

# retrieve endpoint
#
# eksctl get cluster --region eu-west-3
# aws eks describe-cluster --name eks-test --region eu-west-
# aws eks describe-cluster --name eks-test --region eu-west-3 | jq -r .cluster.endpoint

# check scaling
# ---
# eksctl get cluster --region eu-west-3
# eksctl get nodegroup --region eu-west-3 --cluster eks-test

def get_eks_endpoint
  output = `aws eks describe-cluster --name eks-test --region eu-west-3 | jq -r .cluster.endpoint`
  output.strip!
  puts "eks endpoint: #{output}"
  output
end

EKS_CLUSTER_ENDPOINT = get_eks_endpoint

def kubernetes_client
  credentials = Aws::SharedCredentials.new(profile_name: AWS_PROFILE).credentials
  auth_options = {
    bearer_token: Kubeclient::AmazonEksCredentials.token(credentials, EKS_CLUSTER_NAME),
  }

  Kubeclient::Client.new(
    EKS_CLUSTER_ENDPOINT,
    "v1",
    auth_options: auth_options
  )
end

CLIENT = kubernetes_client
