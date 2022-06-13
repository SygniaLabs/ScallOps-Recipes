FROM golang:1.18rc1-windowsservercore-1809
ENV GOPATH=C:\\go


# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Install Chocolatey
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
RUN choco install mingw -y
RUN setx path "%path%;C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin"


ENTRYPOINT ["powershell.exe"]

#Image name: gcr.io/$GCP_PROJECT_ID/golang-mingw:1.18rc1-windowsservercore-1809