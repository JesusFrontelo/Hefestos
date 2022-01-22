#! /bin/bash


##############################################
#####   Checks if Users has or not MFA   #####
#####                                    #####
#####     by Jesús Frontelo Gonzalvez    #####
##############################################

OLD_IFS=$IFS
IFS=$'\n'
OUTPUT_FILE=./USERS_MFA.csv

read -p "Insert the name of your aws config file where account profiles are located: " fich

echo "ACCOUNT|USER|CONSOLE ACCESS|MFA">${OUTPUT_FILE}
for account in `cat ~/.aws/$fich |grep "\["|sed -e 's/\[//g'|sed -e 's/\]//g'|awk -F " " '{print $2}'`;
do
    echo "Gathering" $account"´s users"
    # gathering users info
    for user in `aws iam list-users --profile $account --output json |jq -r '.Users[] | "\(.UserName)"'`;
    do
        # check if user has console access
        console=$(aws iam --profile $account get-login-profile --user-name $user 2>/dev/null |grep -i "PasswordResetRequired" |awk '{print $2}')
        if [ -z $console  ]; then
            echo $user "doesn´t has console access" > /dev/null
            echo $account"|"$user"|NO|NO" >> $OUTPUT_FILE
        else
        # check if has activated MFA 
        mfa=`aws iam list-mfa-devices --user-name $user --profile RepsolEyGSecAdmin-tf 2>/dev/null |jq -r '.MFADevices[] | "\(.UserName) \(.SerialNumber)"'`
	        if [ -z $mfa ]; then
        	    echo $user "in" $account "has console access but No mfa" > /dev/null
                echo $account"|"$user"|YES|NO" >> $OUTPUT_FILE
	        else
	            echo $user "has console access & mfa" > /dev/null
                echo $account"|"$user"|YES|YES" >> $OUTPUT_FILE
	        fi
        fi
   done
cat ${OUTPUT_FILE}|column -t -s '|'   
done
IFS=$OLD_IFS
