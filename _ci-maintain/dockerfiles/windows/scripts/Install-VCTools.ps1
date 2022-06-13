# Build VCTools for VS 2019
Write-Output "Installing VCTools 2019..."
$startinfo = New-Object System.Diagnostics.ProcessStartInfo
$startinfo.FileName = "C:\TEMP\vs_buildtools19.exe"
$startinfo.Arguments = "install --installPath `"c:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools`" --add  Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.Windows10SDK.17134 --includeRecommended --wait --quiet --nocache --norestart"
$startinfo.UseShellExecute = $true
$startinfo.CreateNoWindow = $false
$process = New-Object System.Diagnostics.Process
$process.StartInfo = $startinfo
$process.Start()
$process.WaitForExit()
Write-Output "VCTools 2019 Installed"


# Build VCTools for VS 2017
Write-Output "Installing VCTools 2017..."
$startinfo = New-Object System.Diagnostics.ProcessStartInfo
$startinfo.FileName = "C:\TEMP\vs_buildtools17.exe"
$startinfo.Arguments = "install --installPath `"c:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools`" --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --wait --quiet --nocache --norestart"
$startinfo.UseShellExecute = $true
$startinfo.CreateNoWindow = $false
$process = New-Object System.Diagnostics.Process
$process.StartInfo = $startinfo
$process.Start()
$process.WaitForExit()
Write-Output "VCTools 2017 Installed"
