#!/bin/bash

# To compile NachOS on a Debian environment (x86), you need to
# install the folowing packages:
#  build-essential
#  g++-multilib (on x86-64 only)
# and a MIPS cross-compiler. See below.


# At the end of the document, you will find a script that can help
# to create a cross-compiler on Debian. However, currently (11/2011),
# Debian is migrating toward multiarch and the script does not work.
#
# What I propose is to install Debian packages of a GCC MIPS cross-compiler
# that has been compiled from and on a Debian squeeze (stable)
# These packages should work on Debian stable (squeeze), testing (wheezy)
# and unstable (sid). They also work on Ubuntu sometimes requiring to
# manually install a extra package.
#
# Only the AMD64 and i386 architecture is supported by these pre-compiled
# packages, not the i386 one.
#
# Just run this script (or look at it and type the commands yourself) to
# install a MIPS cross-compiler

set -e

# either this script must be called as root or the user must be
# able to use sudo
if [ "$(whoami)" = root ]; then
	ROOT=
else
	ROOT=sudo
fi

# Check that we are on amd64 or i386
case "$(uname -m)" in
x86_64)
	ARCH=amd64
	;;
i*86)
	ARCH=i386
	;;
*)
	echo "Wrong architechture $(uname -m). Aborting." 1>&2
	exit 1
esac

install_package() {
	local UPDATE=
	if [ "$1" = --no-update ]; then
		UPDATE=": skipping "
		shift
	fi
	$UPDATE $ROOT apt-get -qq update > /dev/null
	local p
	local INST_REQ=
	for p in $1 ; do
		if dpkg -l "$p" | grep -s '^ii' ; then
			:
		else
			INST_REQ=1
			break
		fi
	done
	if [ -z "$INST_REQ" ]; then
		return 0
	fi
	set +x
	echo "**************************************************************"
	echo "* Installing the $1 package(s) from your distrib"
	echo "* $2"
	echo "**************************************************************"
	echo "* Refuse the installation (and try to install it yourself    *"
	echo "* with your usual package manager) if something seems wrong  *"
	echo "* (packages that need to be removed, to many packages        *"
	echo "* upgraded, ...)                                             *"
	echo "**************************************************************"
	set -x
	$ROOT apt-get -qq -y --no-install-recommends install -y $1 $3
}

install_package build-essential "Installing basic development tools (make, gcc, g++, etc.)"
NO_UPDATE=--no-update
echo "MIPS cross compiler seems available in your distrib. Trying to use it"
if ! dpkg --print-foreign-architectures | grep -sq mipsel ; then
    echo "Adding mipsel as a foreign architecture on your system"
    $ROOT dpkg --add-architecture mipsel
    NO_UPDATE=
fi
if test "$ARCH" = amd64 ; then
    GCC_VER=$(gcc --version | head -1 | \
        sed -e 's/.* \([0-9]\+\.[0-9]\+\)\.[0-9]\+\( .*\)\?$/\1/p;d')
    if [ -z "$GCC_VER" ]; then
        echo "Cannot find your GCC version. Aborting."
        exit 1
    fi
    GCC_VER_MAJ="$(echo $GCC_VER | cut -d . -f 1)"
    if ! dpkg --print-foreign-architectures | grep -sq i386 ; then
        echo "Adding i386 as a foreign architecture on your system"
        $ROOT dpkg --add-architecture i386
        NO_UPDATE=
    fi
fi
install_package $NO_UPDATE gcc-mipsel-linux-gnu "Installing the cross-compiler of your distrib. gcc-multiarch and g++-multiarch might be asked to be removed"
if test "$ARCH" = amd64 ; then
    PACKAGES=
    if [ "$(apt-cache -q policy g++-${GCC_VER_MAJ}-multilib)" != "" ] ; then
        PACKAGES="$PACKAGES g++-${GCC_VER_MAJ}-multilib"
    else
        # before gcc 5
        PACKAGES="$PACKAGES libc6-dev:i386 lib32stdc++-$GCC_VER-dev"
    fi
    install_package --no-update "$PACKAGES linux-libc-dev:i386" \
        "in order to compile NachOS on amd64 systems" gcc-mipsel-linux-gnu
fi

echo "Ok, you should be able to compile NachOS"

exit 0


############################################################################

                   ####### #     # ######
                   #       ##    # #     #
                   #       # #   # #     #
                   #####   #  #  # #     #
                   #       #   # # #     #
                   #       #    ## #     #
                   ####### #     # ######

# never go further: creating a MIPS cross-compiler is not working for now