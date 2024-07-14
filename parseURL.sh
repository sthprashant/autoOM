#!/bin/bash

om_version="7.0.8"
backing_db="7.0.8"
platform="rpm"
download_links=""
om_installer_path="./.assets"
pkg_manager=""

# Set the correct package manager for installation
# if [ $platform = "rpm" ]; then
#     pkg_manager="yum"
# elif [ $platform = "deb" ]; then
#     pkg_manager="apt"
# fi

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
        echo "Unsupported Platform : ${linux_check}"
    fi
}

# Get the Download Link From Ops Manager site
get_link() {
    # URL of the MongoDB Ops Manager archive page
    URL="https://www.mongodb.com/try/download/ops-manager/releases/archive"

    # Send a GET request to the URL and save response to a temporary file
    temp_file=$(mktemp)
    curl -s "$URL" >"$temp_file"

    # Check if request was successful, checking the exit code
    if [ $? -ne 0 ]; then
        echo "Error downloading page: $URL"
        exit 1
    fi

    # Find all download links for MongoDB Ops Manager archive om_versions
    #download_links=$(grep -o 'href="[^"]*' "$temp_file" | grep "https://downloads.mongodb.com/on-prem-mms.*${platform}.*${om_version}")
    download_links=$(grep -o 'href="[^"]*' "$temp_file" | grep "https://downloads.mongodb.com/on-prem-mms.*${platform}.*${om_version}.*")

    # Print unique download links
    download_links=$(echo "$download_links" | sort -u | sed 's/href="//')

    if [ -z "${download_links}" ]; then
        echo "Error retreving download link for Ops Manager. Please verify the Platform and Ops Manager version"
        exit 1
    else
        echo "Found download link for ${om_version} for ${platform}- ${download_links}"
    fi
}

# Download installer using the link
download_om() {
    echo "Downloading Ops Manager version ${om_version} from ${download_links}"
    curl -o "${om_installer_path}/om_${om_version}.${platform}" "${download_links}"
    echo "Ops Manager donwload complete"
}

# Download mongodb om_version and install
setup_appdb() {
    echo "Setting up Application database for Ops Manager on the same host"

}

# Execute the program here
#mkdir ./.assets
identitfy_platform
#get_link
#download_om
#setup_appdb
#download_mongodb
#install_mongodb
#install_om
#start_mongodb
#start_om
