# petalinux-docker

## Info
* Stefano Gurrieri <stefano.gurrieri@roj.com>
* Paola Martiner <paola.martiner@roj.com>

## Description
This repository contains the sources of the docker image that can be used to build petalinux images i.e. for Mercury_XU5_PE1_kit BSP. Based on this repository, a docker image can be downloaded (docker pull) or built.

## Requirements

### Docker CE
Click [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/) to install Docker-CE on Ubuntu 64-bit. Other distro Linux are also supported.

**Note:** Check [here](https://docs.docker.com/install/linux/linux-postinstall/) that your user (if not root) is in the docker group.

### Docker Compose
On Ubuntu you can install Docker compose:
```sh
$ sudo apt-get update
$ sudo apt-get install docker-compose
```

or Click [here](https://docs.docker.com/compose/install/) for an eventual particular version.

## Usage of repository

### Get the yocto image (2 different possibilities)
1. Use the already compiled image (preferred solution)
```sh
$ docker pull ghcr.io/roj-italy/petalinux-docker/petalinux:2020.2
```

2. Build the image
- Clone the repository
```sh
$ git clone git@github.com:ROJ-ITALY/petalinux-docker.git
```

- Build the docker image `petalinux-docker`

```sh
$ cd petalinux-docker/
```
- Copy 'petalinux-v2020.2-final-installer.run' file to this folder, then run:
```sh
$ docker build --build-arg PETA_VERSION=2020.2 --build-arg PETA_RUN_FILE=petalinux-v2020.2-final-installer.run -t petalinux:2020.2 .
```

### Check the docker yocto image installed
```sh
$ docker images
```
Typical output of case 1:

```sh
REPOSITORY                                     TAG      IMAGE ID       CREATED         SIZE
ghcr.io/roj-italy/petalinux-docker/petalinux   2020.2   64a63e0b4862   4 hours ago     12.9GB
ubuntu                                         18.04    ad080923604a   9 days ago      63.1MB
```

### Run docker container

```sh
$ docker run -ti --rm -e DISPLAY=$DISPLAY --net="host" -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/enclustra/2020.2:/home/vivado/project ghcr.io/roj-italy/petalinux-docker/petalinux:2020.2 /bin/bash
```
