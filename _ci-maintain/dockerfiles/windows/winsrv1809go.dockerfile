FROM golang:windowsservercore-1809
ENV GOPATH=C:\\go


# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Install Chocolatey
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
# Install multiple packages via Chocolatey
RUN choco install -y powershell-core && choco install -y curl



ENTRYPOINT ["pwsh.exe"]


#Dockerfile Description:
#    Docker file to build Go applications

#Command that can be executed on this image: 
#    Build Go from source:
#    "go build -o <OUTPUT_NAME> <GO_SOURCE_CODE>"
