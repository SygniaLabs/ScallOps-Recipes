FROM ubuntu:18.04
  
RUN apt-get update && apt-get install -y \
    sed \
    xxd \
    libc-bin \
    curl \
    jq \
    perl \
    gawk \
    grep \
    coreutils \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/B1t0n/Chimera.git /opt/chimera
RUN chown root:root -R /opt/chimera
WORKDIR /opt/chimera
COPY dicts/1981words.txt ./
COPY dicts/chimera-comments.txt ./
RUN chmod +x chimera.sh

#./chimera.sh -f shells/Invoke-PowerShellTcp.ps1 -l 3 -o /tmp/chimera.ps1 -v -t powershell,windows,\
#copyright -c -i -h -s length,get-location,ascii,stop,close,getstream -b new-object,reverse,\
#invoke-expression,out-string,write-error -j -g -k -r -p
