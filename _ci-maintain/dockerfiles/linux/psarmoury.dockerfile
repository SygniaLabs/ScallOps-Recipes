FROM mcr.microsoft.com/powershell:ubuntu-18.04
WORKDIR /deploy

# Restore the default Windows shell for correct batch processing.
#SHELL ["/opt/microsoft/powershell/7/pwsh"]

# Install git
RUN /bin/bash -c "apt update && apt install -y git"

# Clone Invoke-Obfuscation
RUN git clone https://github.com/cfalta/PowerShellArmoury.git

# Add the module to the powershell profile for autoloading.
RUN mkdir -p /root/.config/powershell/
RUN echo "Import-Module /deploy/PowerShellArmoury/New-PSArmoury.ps1" >> /root/.config/powershell/Microsoft.PowerShell_profile.ps1
RUN echo "Import-Module /deploy/PowerShellArmoury/Invoke-Shuffle.ps1" >> /root/.config/powershell/Microsoft.PowerShell_profile.ps1
RUN echo "Import-Module /deploy/PowerShellArmoury/ConvertTo-Powershell.ps1" >> /root/.config/powershell/Microsoft.PowerShell_profile.ps1

SHELL ["/opt/microsoft/powershell/7/pwsh","-Command"]

# New-PSArmoury -FromFile ./psfile.ps1 -Password aaddff -Verbose -Path out-file-armed.ps1
