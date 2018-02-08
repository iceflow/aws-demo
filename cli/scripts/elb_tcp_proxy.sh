#!/bin/bash

# List policy types:  Searching for "AttributeName": "ProxyProtocol",
aws elb describe-load-balancer-policy-types

# List elb load-balancer
aws elb describe-load-balancers
# aws elb describe-load-balancers --output table --query 'LoadBalancerDescriptions[*].LoadBalancerName'

aws elb create-load-balancer-policy --load-balancer-name TCP-Proxy --policy-name my-ProxyProtocol-policy --policy-type-name ProxyProtocolPolicyType --policy-attributes AttributeName=ProxyProtocol,AttributeValue=true
aws elb set-load-balancer-policies-for-backend-server --load-balancer-name TCP-Proxy --instance-port 8192 --policy-names my-ProxyProtocol-policy 

#aws elb set-load-balancer-policies-for-backend-server --load-balancer-name my-loadbalancer --instance-port 80 --policy-names my-ProxyProtocol-policy my-SSLNegotiation-policy

## 
aws elb create-load-balancer-policy --load-balancer-name testELBProxy --policy-name my-ProxyProtocol-policy --policy-type-name ProxyProtocolPolicyType --policy-attributes AttributeName=ProxyProtocol,AttributeValue=true
aws elb set-load-balancer-policies-for-backend-server --load-balancer-name testELBProxy --instance-port 5000 --policy-names my-ProxyProtocol-policy 
