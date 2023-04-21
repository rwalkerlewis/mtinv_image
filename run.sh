#!/bin/bash

#docker run --rm -it mtinv

export mtinv_path=${HOME}/projects/Morocco

# docker run --name mtinv-dev --rm -it -v ${mtinv_path}:/home/mtinv-user mtinv
docker run -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /tmp/.docker.xauth:/tmp/.docker.xauth:rw -e XAUTHORITY=/tmp/.docker.xauth \
        --name mtinv-dev --rm -it -v ${mtinv_path}:/home/mtinv-user mtinv
