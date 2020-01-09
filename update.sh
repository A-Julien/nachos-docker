#!/bin/bash

arches="files"

print_header() {
	cat > $1 <<-EOI
	# Nachos Env Build
	#
	# ------------------------------------------------------------------------------
	#               NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
	#
	#                       PLEASE DO NOT EDIT IT DIRECTLY.
	# ------------------------------------------------------------------------------
	
	EOI
}

# Print selected image
print_baseimage() {
	cat >> $1 <<-EOI
    FROM debian:stretch-slim
	LABEL maintainer="Alaimo Julien <julien.alaimo@gmail.com>"
	EOI
}

# Print metadata && basepackages
print_basepackages() {
	cat >> $1 <<-'EOI'	
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
		gdb \
		doxygen \
		valgrind \
		git \
		curl \
		nano \
		wget \
		&& apt-get clean  \
		&& rm -rf /var/lib/apt/lists/ */tmp/* /var/tmp/*
EOI
}

print_add_install(){
	cat >> $1 <<-'EOI'
	ADD install.sh /
EOI
}
# Set working directory and execute command
print_command() {
	cat >> $1 <<-'EOI'
	ADD bashrc /root/.bashrc
	RUN chmod +x install.sh \
		&& ./install.sh \
		&& rm install.sh
EOI
} 

# Build the Dockerfiles
file=Dockerfile
echo -n "Writing $file..."
print_header ${file};
print_baseimage ${file};
print_basepackages ${file};
print_add_install ${file};
print_command ${file};
echo "done"
