function Create-ConfuserXml
{
<#
.SYNOPSIS
Generate the .crproj file needed in order to user ConfuserEx.
.PARAMETER Binaries
The list of binaries to include for the run of ConfuserEx.
.PARAMETER Protections
The list of ConfuserEx Protections to run.
.PARAMETER OutFile
The file path to write the end result into.
.EXAMPLE
.LINK
#>
[CmdletBinding(DefaultParametersetName='Default')]
param
(
    [parameter(Mandatory=$false)][String[]]$Binaries,
    [parameter(Mandatory=$false)][String[]]$Protections,
    [parameter(Mandatory=$false)][String]$OutFile = "$(Join-Path -Path $(Get-Location) -ChildPath Confuser.crproj)"
)

# Set XML Header
$XMLHEADER = "<?xml version=`"1.0`" encoding=`"utf-8`"?>"
Set-Content -Path $OutFile $XMLHEADER

# Set Project Tag
$PROJECTTAG = "<project baseDir=`".`" outputDir=`"Confused`" xmlns=`"http://confuser.codeplex.com`">"
Add-Content -Path $OutFile "$PROJECTTAG"
# Set Rule and Protections
$RULETAG = "<rule preset=`"none`" pattern=`"true`">"
Add-Content -Path $OutFile "`t$RULETAG"
$PROTECTIONTAG = "<protection id=`"%%ID%%`" />"
foreach ($protection in $Protections){
    Add-Content -Path $OutFile $("`t`t$PROTECTIONTAG" -replace '%%ID%%', $protection)
}
Add-Content -Path $OutFile "`t</rule>"

# Set Modules
$MODULETAG = "<module path=`"%%FILEPATH%%`" />"
foreach ($binary in $Binaries){
    Add-Content -Path $OutFile $("`t$MODULETAG" -replace '%%FILEPATH%%', $binary)
}

# Final Touches
Add-Content -Path $OutFile "</project>"
}
