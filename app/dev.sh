#!/bin/bash
# init

terraform plan -var-file="dev.tfvars"

echo -n "Looks alright? Answer 'yes' to continue: "

read REPLY

if [[ $REPLY == "yes" ]]; then
    terraform apply -var-file="dev.tfvars"
else
    echo Aborted
    exit 0
fi