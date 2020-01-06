# Nachos Env Build
#
# ------------------------------------------------------------------------------
#               NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
#                       PLEASE DO NOT EDIT IT DIRECTLY.
# ------------------------------------------------------------------------------

    FROM debian:stretch-slim
LABEL maintainer="Alaimo Julien <julien.alaimo@gmail.com>"
ENV \
    	INITSYSTEM on \
    	DEBIAN_FRONTEND=noninteractive
# Basic build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    	org.label-schema.docker.dockerfile="/Dockerfile" \
    	org.label-schema.name="nachos-env-build"

#--------------Install basepackages--------------# 
RUN apt-get -qq update > /dev/null && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
make \
    	cmake \
build-essential \
git \
curl \
nano \
wget \
&& apt-get clean  \
&& rm -rf /var/lib/apt/lists/ */tmp/* /var/tmp/*
ADD install.sh /
ADD bashrc /root/.bashrc
RUN chmod +x install.sh \
&& ./install.sh \
&& rm install.sh
