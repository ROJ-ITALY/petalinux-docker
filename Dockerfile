FROM ubuntu:18.04

MAINTAINER stefano-gurrieri <stefano.gurrieri@roj.com>

# build with "docker build --build-arg PETA_VERSION=2020.2 --build-arg PETA_RUN_FILE=petalinux-v2020.2-final-installer.run -t petalinux:2020.2.01 ."

# install dependences:

ARG UBUNTU_MIRROR
RUN [ -z "${UBUNTU_MIRROR}" ] || sed -i.bak s/archive.ubuntu.com/${UBUNTU_MIRROR}/g /etc/apt/sources.list

# Set proxy for apt. Uncomment the line below if you need to use a proxy server: set <IP> and <port> with yours.
#RUN echo "Acquire::http::Proxy \"http://192.168.1.107:8080/\";" > /etc/apt/apt.conf

RUN apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
  build-essential \
  sudo \
  tofrodos \
  iproute2 \
  gawk \
  net-tools \
  expect \
  libncurses5-dev \
  tftpd \
  update-inetd \
  libssl-dev \
  flex \
  bison \
  libselinux1 \
  gnupg \
  wget \
  socat \
  gcc-multilib \
  libidn11 \
  libsdl1.2-dev \
  libglib2.0-dev \
  lib32z1-dev \
  libgtk2.0-0 \
  libtinfo5 \
  xxd \
  screen \
  pax \
  diffstat \
  xvfb \
  xterm \
  texinfo \
  gzip \
  unzip \
  cpio \
  chrpath \
  autoconf \
  lsb-release \
  libtool \
  libtool-bin \
  locales \
  kmod \
  git \
  rsync \
  bc \
  u-boot-tools \
  python \
  nano \
  vim \
  iputils-ping \
  parted \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386 &&  apt-get update &&  \
      DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
      zlib1g:i386 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


ARG PETA_VERSION
ARG PETA_RUN_FILE

RUN locale-gen en_US.UTF-8 && update-locale

#make a Vivado user
RUN adduser --disabled-password --gecos '' vivado && \
  usermod -aG sudo vivado && \
  echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN cd /

# from Google Drive
#RUN wget --load-cookies /cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1__Zji9pYQePmZXPVUuA22DjvAPYQAXcu' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1__Zji9pYQePmZXPVUuA22DjvAPYQAXcu" -O ${PETA_RUN_FILE} && rm -rf /cookies.txt
# from FTP ROJ
RUN wget --secure-protocol=auto --ftp-user=petalinux --ftp-password='iKvewshg!6hg' --passive-ftp ftps://ftp.roj.com/petalinux-v2020.2-final-installer.run

COPY accept-eula.sh /

# run the install
RUN chmod a+rx /${PETA_RUN_FILE} && \
  chmod a+rx /accept-eula.sh && \
  mkdir -p /opt/Xilinx && \
  chmod 777 /tmp /opt/Xilinx && \
  cd /tmp && \
  sudo -u vivado -i /accept-eula.sh /${PETA_RUN_FILE} /opt/Xilinx/petalinux && \
  rm -f /${PETA_RUN_FILE} /accept-eula.sh

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

USER vivado
ENV HOME /home/vivado
ENV LANG en_US.UTF-8
RUN mkdir /home/vivado/project
RUN mkdir /home/vivado/patches
COPY --chown=vivado:vivado filemap.py.patch patch_apply.sh /home/vivado/patches/
RUN chmod +x /home/vivado/patches/*.sh

WORKDIR /home/vivado/project

#add vivado tools to path
RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/vivado/.bashrc
