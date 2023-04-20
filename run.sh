#!/bin/bash

#docker run --rm -it mtinv

export mtinv_path=${HOME}/projects/Morocco

docker run --name mtinv-dev --rm -it -v ${mtinv_path}:/home/mtinv-user mtinv
