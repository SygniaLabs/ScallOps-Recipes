FROM ubuntu:18.04
  
RUN apt-get update && apt-get install -y \
    python3 \
    mingw-w64-tools \
    mingw-w64-common \
    g++-mingw-w64 \
    gcc-mingw-w64 \
    upx-ucl \
    osslsigncode \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://git.dylan.codes/batman/darkarmour.git /opt/darkarmour
WORKDIR /opt/darkarmour

# Remove weird illegal character the author added to the banner.
RUN sed -i 's/[\d128-\d255]//g' ./lib/banner.py


#./darkarmour.py -f bins/meter.exe --encrypt xor --jmp -o bins/legit.exe --loop 5
