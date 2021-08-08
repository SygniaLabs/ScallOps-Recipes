# escape=`
# Use the latest Windows Server Core image with .NET Framework 3.5.
ARG BASE_IMAGE=mcr.microsoft.com/dotnet/framework/sdk:3.5-windowsservercore-ltsc2019
FROM $BASE_IMAGE


# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Workload.AzureBuildTools `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
    --remove Microsoft.VisualStudio.Component.Windows81SDK


# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Install Chocolatey
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
# Install multiple packages via Chocolatey
RUN choco install -y powershell-core && choco install -y 7zip.install && choco install -y git && choco install -y hg && choco install -y svn


ENTRYPOINT [ "pwsh.exe" ]
