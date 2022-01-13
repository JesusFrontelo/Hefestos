#! /bin/bash


##############################################
#####          IAM Users List            #####
#####                                    #####
#####    By Jesús Frontelo Gonzalvez     #####
##############################################

### Listado de usuarios en IAM

OLD_IFS=$IFS
IFS=$'\n'

read -p "Insert the name of your aws config file wich account profiles are located: " fich
# header for csv file
echo "user,arn,user_creation_time,last_access,policies" > iam_users_list.csv

# itteration over all your aws accounts
for account in `cat ~/.aws/$fich |grep "\["|sed -e 's/\[//g'|sed -e 's/\]//g'|sed  -e 's/ //g'`;
do
    # itteration over all the users
    for user in `aws iam list-users --profile $account --output json |jq -r '.Users[] | "\(.UserName)"'`;
    do
        # gather user arn
        arn=$(aws iam get-user --user-name $user --profile $account |grep -i "arn" |awk -F " " '{print $2}' |awk -F "\"" '{print $2}')
        # gather user creation date
        create=$(aws iam get-user --user-name $user --profile $account |grep -i "CreateDate" |awk -F " " '{print $2}' |awk -F "\"" '{print $2}')
        # gather last user access
        access=$(aws iam get-user --user-name $user --profile $account |grep -i "Password" |awk -F " " '{print $2}' |awk -F "\"" '{print $2}')
        # gather group policies of the user
        policies=$(aws iam list-groups-for-user --user-name $user --profile $account |jq -r '.Groups[] | "\(.GroupName)"')
        echo $user","$arn","$create","$access","$policies >> iam_users_list.csv
    done
done
IFS=$OLD_IFS