docker run -ti --rm -e DISPLAY=$DISPLAY --net="host" -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/enclustra/2020.2:/home/vivado/project ghcr.io/roj-italy/petalinux-docker/petalinux:2020.2 /bin/bash

