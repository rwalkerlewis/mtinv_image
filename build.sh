xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -

docker build --build-arg user=$USER --build-arg uid=$(id -u) --build-arg gid=$(id -g) --rm -f  Dockerfile -t mtinv .
