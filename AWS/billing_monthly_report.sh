#! /bin/bash


##############################################
#####     Monthly Costs per Account      #####
#####                                    #####
#####    By Jesús Frontelo Gonzalvez     #####
##############################################

OLD_IFS=$IFS
IFS=$'\n'

for account in `cat ~/.aws/config |grep "\["|sed -e 's/\[//g'|sed -e 's/\]//g'|grep Repsol|grep -v ident|awk -F " " '{print $2}'`;
do
	costs=`aws ce get-cost-and-usage --profile $account --time-period Start=2022-09-01,End=2022-10-01 --granularity MONTHLY --metrics "UnblendedCost" |jq -r '.ResultsByTime[] | "\(.Total.UnblendedCost.Amount)"'`
    echo $account "September" $costs 
	echo "Account","Period","Total" >> monthñy_report.csv
	echo $account,"September","$"$costs  >> monthñy_report.csv
done

IFS=$OLD_IFS