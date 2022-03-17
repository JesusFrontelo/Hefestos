#! /bin/bash


##############################################
#####          ACM Certs List            #####
#####                                    #####
#####    By Jesús Frontelo Gonzalvez     #####
##############################################

### Listado de Certificados en ACM

OLD_IFS=$IFS
IFS=$'\n'

read -p "Please, input the certificate name to search: " certificate

function get_certificate () {
    get_cert=`aws acm list-certificates --profile $account --region $region|grep -B1 "$certificate" |awk -F " " '{print $2}'|awk -F "\"" '{print $2}'| head -n1`
    if [ ! -z $get_cert ];
    then
      cert=`aws acm list-certificates --profile $account --region $region|grep -B1 "$certificate" |awk -F " " '{print $2}'|awk -F "\"" '{print $2}'| head -n1`
    fi    
}

echo "Account,Region,ARN,Domain Name,Expiration Date" > certificates.csv
# itteration over all your aws accounts
for account in `cat ~/.aws/config_no_region |grep "\["|sed -e 's/\[//g'|sed -e 's/\]//g'|awk -F " " '{print $2}'`;
do
    regions=("eu-west-1" "us-east-1")
    for region in "${regions[@]}";
    do
      # Get certificates of each account
      get_certificate
      describe_cert=`aws acm describe-certificate --certificate-arn $cert --query 'Certificate.[CertificateArn,DomainName,NotAfter]' --profile $account --region $region 2>/dev/null |grep "arn"`
      if [ ! -z $describe_cert ];
      then 
        arn=`aws acm describe-certificate --certificate-arn $cert --query 'Certificate.[CertificateArn,DomainName,NotAfter]' --profile $account --region $region|grep "arn"|awk -F "\"" '{print $2}'`
        domain_name=`aws acm describe-certificate --certificate-arn $cert --query 'Certificate.[CertificateArn,DomainName,NotAfter]' --profile $account --region $region|grep "$certificate"|awk -F "\"" '{print $2}'`
        exp_date=`aws acm describe-certificate --certificate-arn $cert --query 'Certificate.[CertificateArn,DomainName,NotAfter]' --profile $account --region $region|grep -P '\d{4}-\d{2}-\d{2}'|awk -F "T" '{print $1}'|awk -F "\"" '{print $2}'`
        echo $account","$region","$arn","$domain_name","$exp_date >> certificates.csv
        echo $account","$region","$arn","$domain_name","$exp_date
        cert=""
      fi 
    done 
done