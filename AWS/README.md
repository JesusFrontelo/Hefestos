<div align="center">
  <img align="center" height="90" width="120" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/amazonwebservices/amazonwebservices-original-wordmark.svg" />
  <h1> Scripts AWS </h1>


  <table>
    <tr>
      <th> SCRIPT </th>
      <th> DESCRIPTION </th>
    </tr>
    <tr>
      <td> List_IAM_users.sh </td>
      <td> Itterates over all your aws accounts gathering all the iam users info, like creation date, last access, group policies... </td>
    </tr>
    <tr>
      <td> Describe_SG_ALL_ACCOUNTS.sh </td>
      <td> Describes all the Security Groups in your accounts, except for default VPC, so if you have only the default vpc you should take out this part "--filters Name=is-default,Values=false". To see the info gathered, look for SG_DESCRIPTION.csv, wich is generated in the same folder where the script is</td>
    </tr>
    <tr>
      <td> MFA_User_Check.sh </td>
      <td> Gather all the users info, to generate a list if the user has or not the followings: Console Access, MFA Activated. The Output file is USERS_MFA.csv</td>
    </tr>
    <tr>
      <td> SSMUpdate.ps1 </td>
      <td> Install/Update AWS SSM Agent to the latest version in Windows Server. </td>
    </tr>
    <tr>
      <td> List_ACM_certificates.sh </td>
      <td> Itterates over all your aws accounts and regions (you should input them inside the script) and shows certificate arn, domain name and expiration date, and exports all the data to a .csv file. </td>
    </tr>    
    <tr>
      <td> billing_monthly_report.sh </td>
      <td> List Last Month Cost from Cost Explorer of each account. </td>
    </tr>       
  </table>
</div>
