Write-Host "This script erases older files from a path" -ForegroundColor Green

$ruta = Read-Host -Prompt 'Type absolute path to the folder: '
$older = Read-Host -Prompt 'Specify maximum age of the files to preserve: '

Write-Host "Files older than $older will be deleted from path $ruta"
Do { $answer = Read-Host  -Prompt "¿Are you sure? (Y/N): " } While ($answer -notmatch "Y|N|y|n")

forfiles /p "$ruta" /s /d -$older /c "cmd /c del @file /Q"
