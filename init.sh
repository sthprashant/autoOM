#!/bin/bash

pkg_manager=""
platform=""
om_version="7.0.8"

### Identify platform for the script
identitfy_platform() {
    linux_check=$(uname)
    if [ "${linux_check}" = "Linux" ]; then
        if command -v apt-get &>/dev/null; then
            platform="deb"
            pkg_manager="apt-get"
            echo "Setting platform as deb and package manager as apt-get"
        elif command -v yum &>/dev/null; then
            platform="rpm"
            pkg_manager="yum"
            echo "Setting platform as rpm and package manager as yum"
        else
            echo "Unable to Identify Platform"
        fi
    else
        echo "Unsupported Platform : ${linux_check} for Ops Manager Installation"
        exit 1
    fi
}

### Install/verify requirements - node, git, m
install_reqs() {
    echo "Installing packages. This may take some time"
    sudo "${pkg_manager}" -y update &> /dev/null
    sudo "${pkg_manager}" install -y git make nodejs npm curl &> /dev/null

    echo " Installing mongodb dependencies"

    if [ "${platform}" = "rpm" ]; then
        sudo yum -y install cyrus-sasl cyrus-sasl-gssapi cyrus-sasl-plain krb5-libs libcurl net-snmp openldap openssl xz-libs
    fi

    if [ "${platform}" = "deb" ]; then
        sudo apt-get -y install libcurl4 libgssapi-krb5-2 libldap-2.5-0 libwrap0 libsasl2-2 libsasl2-modules libsasl2-modules-gssapi-mit snmp openssl liblzma5
    fi

    echo "Installing m using NPM. More info about m: https://github.com/aheckmann/m"
    sudo npm install -g m
}


### set up environment variables based on user input
setup_vars() {
    echo "${pkg_manager} \n ${platform}"
    echo "setting up environment variables"
    export PKG_MANAGER="$pkg_manager"
    export PLAT="$platform"
    export OMV="7.0.8"

    echo "environment variable setup complete"
    echo "PKG_MANAGER=$PKG_MANAGER "
    echo "PLAT=$PLAT"
}

identitfy_platform
install_reqs
setup_vars
./appdb.sh