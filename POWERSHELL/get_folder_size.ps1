
$targetfolder=Read-Host -Prompt 'Input path (i.e: D:\ or D:\logs\)'

$dataColl = @()

gci -force $targetfolder -ErrorAction SilentlyContinue | ? { $_ -is [io.directoryinfo] } | % {
    $len = 0
    gci -recurse -force $_.fullname -ErrorAction SilentlyContinue | % { $len += $_.length }
    $foldername = $_.fullname
    $foldersize= '{0:N2}' -f ($len / 1Gb)
    $dataObject = New-Object PSObject
    Add-Member -inputObject $dataObject -memberType NoteProperty -name “Folder” -value $foldername
    Add-Member -inputObject $dataObject -memberType NoteProperty -name “Size in GB” -value $foldersize
    $dataColl += $dataObject
}

$dataColl | Out-GridView -Title “Size of subdirectories”