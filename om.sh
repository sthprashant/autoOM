#!/bin/bash


om_version="7.0.8"
backing_db="7.0.8"
platform="rpm"
download_links=""
om_installer_path="./.assets"
pkg_manager=""

# Get the Download Link From Ops Manager site
get_download_link() {
    # URL of the MongoDB Ops Manager archive page
    URL="https://www.mongodb.com/try/download/ops-manager/releases/archive"
    #https://www.mongodb.com/try/download/enterprise-advanced/releases/archive

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
    om_fullpath="${om_installer_path}/om_${om_version}.${platform}"
    local verify_dir=$(ls -d)
    echo "local directory output is $verify_dir"
    if [ -z "$verify" ]; then
        echo "unable to find $om_installer_path. Creating one to download the Ops Manager installer"
        mkdir -p "$om_installer_path"
    fi
    echo "Downloading Ops Manager version ${om_version} from ${download_links}"
    #curl -o "${om_installer_path}/om_${om_version}.${platform}" "${download_links}"
    curl -o "$om_fullpath" "${download_links}" --silent
    echo "Ops Manager donwload complete"
}

install_om() {
    echo "Installing manager using $om_fullpath"
    sudo rpm -ivh "$om_fullpath"
    echo "Installation complete"
    rm -R "$om_fullpath"
    sudo service mongodb-mms start
}

#install_om
#configure_om
#start_om