FROM mcr.microsoft.com/dotnet/framework/sdk:4.8

SHELL ["cmd", "/S", "/C"]

ADD https://aka.ms/vs/16/release/vs_buildtools.exe /TEMP/vs_buildtools19.exe
ADD https://aka.ms/vs/15/release/vs_buildtools.exe /TEMP/vs_buildtools17.exe
COPY ./scripts/Install-VCTools.ps1 /TEMP/
	
RUN PowerShell /TEMP/Install-VCTools.ps1
