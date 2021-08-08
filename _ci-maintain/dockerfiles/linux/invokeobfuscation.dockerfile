FROM mcr.microsoft.com/powershell:ubuntu-18.04
WORKDIR /deploy

# Restore the default Windows shell for correct batch processing.
#SHELL ["/opt/microsoft/powershell/7/pwsh"]

# Install git
RUN /bin/bash -c "apt update && apt install -y git"

# Clone Invoke-Obfuscation
RUN git clone https://github.com/danielbohannon/Invoke-Obfuscation.git

# Add the module to the powershell profile for autoloading.
RUN mkdir -p /root/.config/powershell/
RUN echo "Import-Module ./Invoke-Obfuscation/Invoke-Obfuscation.psd1" > /root/.config/powershell/Microsoft.PowerShell_profile.ps1

SHELL ["/opt/microsoft/powershell/7/pwsh","-Command"]

#Invoke-Obfuscation -ScriptPath /deploy/source.ps1 -Command 'Token/\All/\1,Encoding/\1,Launcher/\Stdin++/\234,Clip,OUT output.ps1' -Quiet"
