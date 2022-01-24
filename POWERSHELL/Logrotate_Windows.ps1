Write-Host "This script erases older files from a path" -ForegroundColor Green

$ruta = Read-Host -Prompt 'Type absolute path to the folder: '
$older = Read-Host -Prompt 'Specify maximum age of the files to preserve: '

Write-Host "Files older than $older will be deleted from path $ruta"
Do { $answer = Read-Host  -Prompt "¿Are you sure? (Y/N): " } While ($answer -notmatch "Y|N|y|n")

forfiles /p "$ruta" /s /d -$older /c "cmd /c del @file /Q"

$Trigger = New-ScheduledTaskTrigger -Daily -At 9am
$Action  =  New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "forfiles /p '$ruta' /s /d -$older /c 'cmd /c del @file /Q'"
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Log Rotate" -Description "This task erase files older than $older days from the path $ruta"