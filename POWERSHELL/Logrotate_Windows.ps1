Write-Host ""
Write-Host "This script creates a task scheduler wich erases older files from a path" -ForegroundColor Green
Write-Host ""

$ruta = Read-Host -Prompt 'Type absolute path to the folder'
Write-Host ""
$older = Read-Host -Prompt 'Specify maximum age, in days, of the files to preserve'

Write-Host "Files older than $older days will be deleted from path $ruta"
Do { $answer = Read-Host  -Prompt "¿Are you sure? (Y/N)" } While ($answer -notmatch "Y|N|y|n")

$taskTrigger = New-ScheduledTaskTrigger -Daily -At 9am
$taskAction  =  New-ScheduledTaskAction -Execute "C:\Windows\System32\forfiles.exe" -Argument "/p $ruta /s /d -$older /c `"cmd /c del @file /Q`""
$taskName = "Log Rotate"
$description = "This task erase files older than $older days from the path $ruta"

Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -TaskName $taskName -Description $description -User "NT AUTHORITY\SYSTEM"