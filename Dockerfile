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
      wget \
      gdb \
      valgrind \
      vim-common \
      vim-runtime \
      vim-nox \
      gfortran \
      gcc \
      libc6-dev \
      libc6 \
      nano \
      git \
      gmt \
      csh \
      tcsh \
      sqlite \
      imagemagick \
      python3 \
      sudo \
      default-jre \
      gmt-gshhs-full \
      default-jdk \
      libopenmpi-dev \
      openmpi-bin \
      man \
      libncurses-dev \
      tar \
      gzip \
      openmpi-common

# # --------------------------------------------------------------------------- 80

from os-update as build-certs-doi

ONBUILD COPY docker/certs/ /usr/local/share/ca-certificates
ONBUILD RUN update-ca-certificates
ONBUILD ENV CERT_PATH=/etc/ssl/certs CERT_FILE=DOIRootCA2.pem

from os-update as build-nocerts
ONBUILD ENV CERT_PATH=no  CERT_FILE=no

# --------------------------------------------------------------------------- 80
from build-${BUILD_ENV} as build-deps

# Create 'mtinv-user' user
ENV MTINV_USER=mtinv-user

ENV DEV_DIR=/opt/mtinv \
	BUILD_DIR=/home/mtinv \
	MTINV=mtinv3 \
	HOME=/home/${MTINV_USER} \
	PATH_ORIG=${PATH}

# Create mtinv-user
RUN useradd -m --create-home --shell /bin/bash $MTINV_USER && echo "${MTINV_USER}:mtinv" | chpasswd && adduser ${MTINV_USER} sudo
RUN mkdir $DEV_DIR \
  && chown $MTINV_USER $DEV_DIR \
  && chgrp $MTINV_USER $DEV_DIR \
  && mkdir -p $BUILD_DIR/build \
  && chown -R $MTINV_USER $BUILD_DIR \
  && chgrp -R $MTINV_USER $BUILD_DIR

# --------------------------------------------------------------------------- 80
# Build MTINV
USER $MTINV_USER
WORKDIR ${DEV_DIR}
RUN git clone https://github.com/rwalkerlewis/mtinv ${MTINV} \
        && cd ${MTINV} \
        && git checkout local_updates \        
			  && make all
WORKDIR ${DEV_DIR}/${MTINV}/src
#RUN make all 

# --------------------------------------------------------------------------- 80
# Build CPS
USER ${MTINV_USER}
WORKDIR ${DEV_DIR}
RUN wget --no-check-certificate http://www.eas.slu.edu/eqc/eqc_cps/Download/NP330.Nov-08-2022.tgz \
        && gunzip -c NP330.Nov-08-2022.tgz | tar xf - \
        && cd PROGRAMS.330 \
        && ./Setup LINUX6440 \
        && ./C
# Set PATH
ENV PATH=${DEV_DIR}/${MTINV}/bin:${DEV_DIR}/PROGRAMS.330/bin:/usr/lib/gmt/bin:${PATH}
ENV MANPATH=${MANPATH}:${DEV_DIR}/${MTINV}/man			  
# Setup user and environment
#WORKDIR /home/$MTINV_USER


#RUN rm -fr /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log

WORKDIR $HOME

CMD /bin/bash
