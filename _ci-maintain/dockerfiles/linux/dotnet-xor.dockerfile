FROM mcr.microsoft.com/powershell:ubuntu-18.04
WORKDIR /deploy
COPY scripts/Invoke-Xor.ps1 ./

RUN apt-get update && apt-get install -y \
    xxd \
    && rm -rf /var/lib/apt/lists/*
#
# Add the module to the powershell profile for autoloading.
RUN mkdir -p /root/.config/powershell/
RUN echo "Import-Module /deploy/Invoke-Xor.ps1" > /root/.config/powershell/Microsoft.PowerShell_profile.ps1

SHELL ["/opt/microsoft/powershell/7/pwsh","-Command"]

#Invoke-Xor -Key 0x45 -Binary MyBin.exe -OutFile path.exe -Verbose