#!/bin/bash

version="7.0.8"
platform="rpm"
download_links=""
om_installer_path="/Users/prashant.shrestha/Desktop/test/extract/tests"

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

    # Find all download links for MongoDB Ops Manager archive versions
    #download_links=$(grep -o 'href="[^"]*' "$temp_file" | grep "https://downloads.mongodb.com/on-prem-mms.*${platform}.*${version}")
    download_links=$(grep -o 'href="[^"]*' "$temp_file" | grep "https://downloads.mongodb.com/on-prem-mms.*${platform}.*${version}.*")

    # Print unique download links
    download_links=$(echo "$download_links" | sort -u | sed 's/href="//')
    echo "Found download link for ${version} for ${platform}- ${download_links}"
    #echo "$download_links"
}

# Download installer using the link
download_om() {
    echo "Downloading Ops Manager version ${version} from ${download_links}"
    curl -o "${om_installer_path}/om_${version}.${platform}" "${download_links}"
    echo "Ops Manager donwload complete"
}

# Download compatible mongodb version and install
setup_appdb() {
    echo "Setting up Application database for Ops Manager on the same host"
    
}

# Execute the program here
get_link
download_om
