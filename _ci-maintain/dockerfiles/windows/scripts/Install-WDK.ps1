# Install WDK
Write-Output "Installing WDK"
$startinfo = New-Object System.Diagnostics.ProcessStartInfo
$startinfo.FileName = "C:\TEMP\wdksetup.exe"
$startinfo.Arguments = "/q /norestart"
$startinfo.UseShellExecute = $true
$startinfo.CreateNoWindow = $false
$process = New-Object System.Diagnostics.Process
$process.StartInfo = $startinfo
$process.Start()
$process.WaitForExit()
Write-Output "WDK Installed"

# Install WDK.vsix manually by extracting its contents.
Copy-Item "C:\Program Files (x86)\Windows Kits\10\Vsix\VS2019\WDK.vsix" 'C:\TEMP\wdkvsix.zip'
Expand-Archive 'C:\TEMP\wdkvsix.zip' -DestinationPath 'C:\TEMP\WdkVsix'
Copy-Item 'C:\TEMP\WdkVsix\$MSBuild\Microsoft\*' -Destination 'C:\program files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Microsoft' -Recurse -Force
Remove-Item 'C:\TEMP\WdkVsix' -Force -Recurse 
Remove-Item 'C:\TEMP\wdkvsix.zip' -Force
