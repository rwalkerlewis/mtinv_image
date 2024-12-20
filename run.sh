#!/bin/bash

#docker run --rm -it mtinv

export mtinv_path=${HOME}/Projects/mtinv_examples


xhost +local:*
# docker run --name mtinv-dev --rm -it -v ${mtinv_path}:/home/mtinv-user mtinv
docker run --privileged -v /tmp/.docker.xauth:/tmp/.docker.xauth:rw -e XAUTHORITY=/tmp/.docker.xauth \
        --name mtinv-dev --rm -it -v ${mtinv_path}:/home/mtinv-user -e DISPLAY=$DISPLAY \
        --user $(id -u):$(id -g) --net=host \
         -v /tmp/.X11-unix:/tmp/.X11-unix \
         mtinv
