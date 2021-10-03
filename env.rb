require "bundler/setup"
Bundler.require :default

require_relative "lib/slack_webhook"
include SlackWebhook

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

EKS_CA = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1Ea3lOekUyTURjME0xb1hEVE14TURreU5URTJNRGMwTTFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBS2dECm1henVRemZoeHFZQ3VYVjFjR3NyTVhOYTl3SkhYdHRPQ2huek5rTGhzYTRoZWNDaTBZWlpIdlNjUlUzWjF3U1QKT1Iwa2V5VjVoeVZrWVJ1dmRNeXhxZWpjN2JzZEVWTEVxNzNPekVVQkpaZHFWalpYeFI4Qzdwdi9adDdIeEFLRApqVHY5eHBUL3R1NGgxTzFtTTZNVitwZHZXM1Vha2xvMlhRNlhkK0MvN3VtRHRia21vRDJwMmN2TWFhLzlvZ3RyCjNsOWliaDJMSmNTeUs0Q0ZlU3lLVjdaZDlqZG12ajRCRHJ2ci9WSGQ2M1YycGxma3AyaWxFak5vQS9kWUd2M1EKbStya2pSU1FUQTlTTUQvenhMQmRzdlFTWmVZL0tlSmxaVTN6eU5JSThMdWxYRGYrZEp2U2hGcFdwTzEwMFF3RgpvcVRRNGVLSHlGcEZ1UEs4QjZVQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZMTlV5RGJqV21QTVkxVmFlLzQvSFJFVzJQN0VNQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFCM1dEZ0ljNm4yZnFNUFRBQis0VTYxaU4yN2ZYbU9VU2dLVU42MzUwVzBHVU5yRDJ3VAprd3BvTFFMMTFLandoeUNRbUVabVVWNHNuamVJZTd5UUpEamsrWk5ZRDVBZWhVVDkvK0pRTDFMeXIvMUw5eElLCk1BSEtVblY2eHNGc0pkd2FpVnJZSVBjZ2oyeDA1QmNXdEtYb1p6RDRJa09pMmdaajdVQlBEbFBEOTZSdTBnSkQKT0RvWUgwcDRwQXBtaFJhQmtnOWxiNHB0L1l3VEVrQmZEMTJKTTBodUkwL2JQRXZrVWxCdkQrTktJTDdJNGNGUgpwVys1SnVFRmk0eWxycnFwcUU5Qk5VOGdIcnl2V0ZZM1d3VDFjekhNVU93Q080TzFGbWlJRkpKYVlUNFFVRHNOCkM1L2krbG5iSDl1R1gwdmJsL2FaUWc1Ulh6bUd3Ni9mK3JSQwotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="


def kubernetes_client
  credentials = Aws::SharedCredentials.new(profile_name: AWS_PROFILE).credentials
  auth_options = {
    bearer_token: Kubeclient::AmazonEksCredentials.token(credentials, EKS_CLUSTER_NAME),
  }
  # TODO: use cert in production
  ssl_options = { verify_ssl: OpenSSL::SSL::VERIFY_NONE }

  Kubeclient::Client.new(
    EKS_CLUSTER_ENDPOINT,
    "v1",
    auth_options: auth_options,
    ssl_options:  ssl_options
  )
end

CLIENT = kubernetes_client
