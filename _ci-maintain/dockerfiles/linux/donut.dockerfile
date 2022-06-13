FROM ubuntu:18.04
  
RUN apt-get update && apt-get install -y git curl build-essential ;\
    git clone http://github.com/thewover/donut.git /opt/donut ;\
    chown root:root -R /opt/donut ;\
    cd /opt/donut ;\
    make
