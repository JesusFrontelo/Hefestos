# Download SSM Agent
Invoke-WebRequest "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe" -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe
# Install SSM Agent
Start-Process -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe -ArgumentList "/S"
# Restart Service
Restart-Service AmazonSSMAgent 
## Erase downloaded file
rm -Force $env:USERPROFILE\Desktop\SSMAgent_latest.exe
# Check Installed SSM Agent Version
Get-WmiObject Win32_Product | Where-Object {$_.Name -eq 'Amazon SSM Agent'} | Select-Object Name,Version




