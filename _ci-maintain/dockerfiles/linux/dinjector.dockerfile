FROM ubuntu:18.04
  
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \    
    curl \
    wget \
    python3-pycurl \
    jq \
    git \
    xxd \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/snovvcrash/DInjector.git /opt/dinjector
WORKDIR /opt/dinjector