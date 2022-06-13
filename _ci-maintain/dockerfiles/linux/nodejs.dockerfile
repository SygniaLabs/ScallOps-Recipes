FROM ubuntu:18.04
  
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    curl \
    && rm -rf /var/lib/apt/lists/*
RUN npm i --save atob
RUN npm install n -g
RUN n stable
RUN hash -r
RUN node --version
