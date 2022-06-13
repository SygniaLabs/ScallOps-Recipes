FROM mcr.microsoft.com/dotnet/framework/sdk:3.5-windowsservercore-ltsc2019
WORKDIR C:/ConfuserEx/
COPY confuserex-resources ./
SHELL [ "powershell", "-Command" ]

RUN "curl \"https://github.com/mkaring/ConfuserEx/releases/download/v1.6.0/ConfuserEx-CLI.zip\" -o ConfuserEx-CLI.zip"
RUN "Expand-Archive ConfuserEx-CLI.zip"

ENTRYPOINT ["powershell.exe"]