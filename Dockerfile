# Download base image ubuntu 22.04 / Jammy
FROM ubuntu:22.04

# LABEL about the custom image
LABEL maintainer="abelragazzo@gmail.com"
LABEL version="0.1"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Region
ENV TZ Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Locale
ENV LANG id_ID.UTF-8
ENV LANGUAGE id_ID:en
ENV LC_ALL id_ID.UTF-8

# Update Ubuntu Software repository
RUN \
   apt-get update \
   && apt-get install -y curl locales && locale-gen $LANG \
   && apt-get -y autoclean

# Install nano
RUN apt-get install -y nano

# Install iputils
RUN apt-get install -y iputils-ping

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# use changes to package.json to force Docker not to use the cache
# when we change our application's nodejs dependencies:
COPY package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /srv/cobaCICD && cp -a /tmp/node_modules /srv/cobaCICD

# Menentukan direktori kerja di dalam kontainer
WORKDIR /srv/cobaCICD

# Menyalin kode aplikasi ke dalam kontainer
COPY . /srv/cobaCICD

# Mengekspos port aplikasi
EXPOSE 62303

# Menjalankan perintah lain yang diperlukan untuk menjalankan aplikasi Anda
CMD ["npm", "start"]
