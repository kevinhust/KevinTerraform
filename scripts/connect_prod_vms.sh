#!/bin/bash

# 配置 SSH 代理
eval $(ssh-agent -s)
ssh-add ~/.ssh/kevin-terraform-key.pem

# 通过 Bastion Host 连接到生产环境的 VM
# 使用方法: ./connect_prod_vms.sh [vm1|vm2]

BASTION_HOST="ec2-user@BASTION_IP"
VM1_PRIVATE_IP="VM1_PRIVATE_IP"
VM2_PRIVATE_IP="VM2_PRIVATE_IP"

case "$1" in
  "vm1")
    echo "连接到生产环境 VM1..."
    ssh -J $BASTION_HOST ec2-user@$VM1_PRIVATE_IP
    ;;
  "vm2")
    echo "连接到生产环境 VM2..."
    ssh -J $BASTION_HOST ec2-user@$VM2_PRIVATE_IP
    ;;
  *)
    echo "使用方法: $0 [vm1|vm2]"
    exit 1
    ;;
esac 