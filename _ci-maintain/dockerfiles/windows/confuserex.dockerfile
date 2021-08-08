FROM mcr.microsoft.com/dotnet/framework/sdk:3.5-windowsservercore-ltsc2019
WORKDIR C:/ConfuserEx/
COPY scripts/Create-ConfuserXml.ps1 ./
SHELL [ "powershell", "-Command" ]

RUN "curl \"https://github.com/mkaring/ConfuserEx/releases/download/v1.5.0/ConfuserEx-CLI.zip\" -o ConfuserEx-CLI.zip"
RUN "Expand-Archive ConfuserEx-CLI.zip"

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Install Chocolatey
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
# Install multiple packages via Chocolatey
RUN choco install -y powershell-core && choco install -y curl

SHELL ["pwsh.exe", "-Command"]
RUN Set-Content -Path $PSHome\profile.ps1 '. .\Create-ConfuserXml.ps1'

ENTRYPOINT ["pwsh.exe"]


#Create-ConfuserXml -Binaries "SharpUp.exe" -OutFile Sharp.crproj -Protections "anti debug","anti dump","anti ildasm","anti tamper","constants","ctrl flow","invalid metadata","ref proxy","rename","resources"
#Start-Process .\ConfuserEx-CLI\Confuser.CLI.exe .\Sharp.crproj
