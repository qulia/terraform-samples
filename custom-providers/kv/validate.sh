#!/bin/bash

terraformStateFile="terraform.tfstate"
if [ -f $terraformStateFile ]; then
    rm $terraformStateFile
fi

export TF_LOG=DEBUG
terraform init
# first time apply will call create
terraform apply

read -p "Try
 - updating the value in the kvStore file before second apply to trigger update,
 - or remove the entry to re-create
 - or leave it as is for no-op.
Press any key to continue execution..."

# Second apply
terraform apply

# will call delete
terraform destroy

# state file should be empty