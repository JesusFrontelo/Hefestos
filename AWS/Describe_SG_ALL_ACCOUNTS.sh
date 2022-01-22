#!/bin/bash

### ENV
OLD_IFS=$IFS
IFS=$'\n'
OUTPUT_FILE=~/inventario_aws_reyg_sg-rules_v2.txt

read -p "Insert the name of your aws config file where account profiles are located: " fich

# Generatin header for output file
echo "ACCOUNT|SG|PORT|CIDR">${OUTPUT_FILE}

#here we get all the accounts name, so check if it gathers the right parameter
for accounts in `cat ~/.aws/$fich |grep "\["|sed -e 's/\[//g'|sed -e 's/\]//g'`;
do

    vpc=`aws ec2 describe-vpcs --profile ${accounts} --query 'Vpcs[].VpcId[]' --filters Name=is-default,Values=false --output text`
    echo "ACCOUNT ===================================================== ${accounts} ============================================================"
    echo "Generating" $accounts "data"       
    for command in `aws ec2 describe-security-groups --profile ${accounts} --output json --filters Name=vpc-id,Values=${vpc} | jq -r '.SecurityGroups[] | "\(.GroupName) \(.IpPermissions[].FromPort) \(.IpPermissions[].IpRanges[].CidrIp)"'`
    do  
        sg_print=`echo $command | awk {'print $1'}`
        port_print=`echo $command | awk {'print $2'}`
        cidr_print=`echo $command | awk {'print $3'}`
        echo "$accounts|$sg_print|$port_print|$cidr_print" >> $OUTPUT_FILE
    done
cat ${OUTPUT_FILE}|column -t -s '|'
done
$IFS=$OLD_IFS
