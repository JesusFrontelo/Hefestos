$user = Read-Host -Prompt 'Type user name: '

## Check and create the user
$check_user=(Get-LocalUser | Where-Object {$_.Name -eq '$user'}).Count

 if ( $check_user -eq 1 ) {
    Write-Host "$user already exists in this system"
 } else {
    Write-Host "$user doesn´t exists in this system"
    Write-Host "Creating user $user"
    $pass = Read-Host 'Please, specify a password for $user' -AsSecureString
    New-LocalUser -Name "$user" -Password (ConvertTo-SecureString "$pass" -AsPlainText -force)
    Add-LocalGroupMember -Group "Administrators" -member '$user'
    cmd /c winrm set winrm/config/service/auth @{Basic="true"}
    cmd /c winrm set winrm/config/service @{AllowUnencrypted="true"}
 }