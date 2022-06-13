FROM gcr.io/at-pipline/winsrv-netsdk48-vctools17-19

SHELL ["cmd", "/S", "/C"]

COPY ./scripts/Install-WDK.ps1 /TEMP/

ADD https://download.microsoft.com/download/c/f/8/cf80b955-d578-4635-825c-2801911f9d79/wdk/wdksetup.exe /TEMP/wdksetup.exe

RUN PowerShell /TEMP/Install-WDK.ps1
