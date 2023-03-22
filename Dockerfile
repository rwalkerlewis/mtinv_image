ARG BUILD_ENV=nocerts
FROM ubuntu:16.04 as os-update
MAINTAINER Robert Walker <langleyreview@gmail.com>

ENV BUILD_ENV=${BUILD_ENV}

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
      g++ \
      make \
      file \
      libtool \
      curl \
      gdb \
      valgrind \
      vim-common \
      vim-runtime \
      vim-nox \
      gfortran \
      gcc \
      nano \
      git \
      gmt \
      csh \
      tcsh \
      sqlite \
      imagemagick \
      python3 \
      default-jre \
      libopenmpi-dev \
      openmpi-bin \
      openmpi-common

# ------------------------------------------------------------------------------
from os-update as build-certs-doi

ONBUILD COPY docker/certs/ /usr/local/share/ca-certificates
ONBUILD RUN update-ca-certificates
ONBUILD ENV CERT_PATH=/etc/ssl/certs CERT_FILE=DOIRootCA2.pem

from os-update as build-nocerts
ONBUILD ENV CERT_PATH=no  CERT_FILE=no

# ------------------------------------------------------------------------------
from build-${BUILD_ENV} as build-deps

# Create 'mtinv-user' user
ENV MTINV_USER=mtinv-user

ENV PREFIX_DIR=/opt/mtinv \
	BUILD_DIR=/home/mtinv \
	MTINV=mtinv3 \
	HOME=/home/${MTINV_USER} \
	PATH_ORIG=${PATH}

# Create mtinv-user
RUN useradd --create-home --shell /bin/bash $MTINV_USER
RUN mkdir $PREFIX_DIR \
  && chown $MTINV_USER $PREFIX_DIR \
  && chgrp $MTINV_USER $PREFIX_DIR \
  && mkdir -p $BUILD_DIR/build \
  && chown -R $MTINV_USER $BUILD_DIR \
  && chgrp -R $MTINV_USER $BUILD_DIR

# Build MTINV
USER $MTINV_USER
WORKDIR $BUILD_DIR
RUN git clone https://github.com/rwalkerlewis/mtinv ${MTINV} \
			  && cd mtinv3 \
			  && make all

ENV PATH=${BUILD_DIR}/${MTINV}/bin:${PYLITHDEPS_DIR}/bin:${PATH}
			  


# Setup user and environment
#WORKDIR /home/$MTINV_USER


#RUN rm -fr /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log


CMD /bin/bash
