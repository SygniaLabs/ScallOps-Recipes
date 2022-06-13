FROM ubuntu:18.04
  
RUN apt-get update && apt-get install -y \
    python3 \
    curl \
    wget \
    python3-pycurl \
    jq \
    git \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*