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

RUN git clone https://github.com/h4wkst3r/InvisibilityCloak.git /opt/InvisibilityCloak
# Fix for input file encoding errors, as some tools could not be loaded properly. 
RUN sed -i 's/\(.*\)open(\(.*\))$/\1open(\2, encoding="utf8")/' /opt/InvisibilityCloak/InvisibilityCloak.py
COPY scripts/invisicloak-overwrite-envs.sh /opt/InvisibilityCloak/invisicloak-overwrite-envs.sh
RUN chmod 751 /opt/InvisibilityCloak/invisicloak-overwrite-envs.sh
WORKDIR /opt/InvisibilityCloak