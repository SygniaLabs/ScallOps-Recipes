function Invoke-Xor
{
<#
.SYNOPSIS
Xor a .net binary for reflective loading in powershell.
.PARAMETER Key
Set the key to use for the operation, Default is 0x30.
.PARAMETER Binary
The target .NET binary to run the encryption on.
.PARAMETER OutFile
The file to write the base64 encoded encrypted binary into.
.EXAMPLE
.LINK
#>
[CmdletBinding(DefaultParametersetName='Default')]
param
(
    [parameter(Mandatory=$false)][Int]$Key = 0x30,
    [parameter(Mandatory=$true)][String]$Binary,
    [parameter(Mandatory=$false)][String]$OutFile = "$(Join-Path -Path $(Get-Location) -ChildPath Base64.txt)"
)

$filebytes = [IO.File]::ReadAllBytes($Binary)
Write-Verbose "$($filebytes.count) Bytes were read from file $Binary."
Write-Verbose "Encrypting using $Key XOR key"
for($i=0; $i -lt $filebytes.count ; $i++)
{
    $filebytes[$i] = $filebytes[$i] -bxor $Key
}

# Convert the encrypted binary to base64
$base64 = [Convert]::ToBase64String($filebytes)

# Write the base64 to a file
Write-Verbose "Writing Encoded Base64 String to $OutFile."
[IO.File]::WriteAllLines($OutFile, $base64)
}