# check installed mongod
# verify_mongod() {
#      echo "verifying mongodb installation"
#     # mdb_output=$(mongod --version | jq -r '.version')
#     #jq '.[0]' $mdb_output
#     #echo "$mdb_output"
#     version=$(mongod --version | grep "db version" | awk '{print $3}')
#     echo "$version"
# }


# install mongod
#configure mongod
# start mongod

setup_appdb() {
    #install required mongod based on OM version
    echo "OM version is currently set to $OMV"
}
