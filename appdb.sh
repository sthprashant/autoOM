
#!/bin/bash

dbPath="/data"
APPDB_PORT=27017

copy_binaires() {
    # extracting some values with text manipulation
    awk '{printf "%s", $0}' .moutput.txt > .fixedmoutput.txt
    mdb_ver=$(awk -F 'MongoDB Server ' '{print $2}' "./.fixedmoutput.txt" | awk -F ', ' '{print $1}')

    bin_path=$(m bin $mdb_ver)
    rm ./.moutput.txt ./.fixedmoutput.txt # quick cleanups

    local existing_binaries=$(ls /usr/bin/mongod)

    if [ -z "$existing_binaries" ]; then
        sudo cp $bin_path/* /usr/bin #only copy binaries if it does not exists
    fi
    
}

setup_appdb(){

    #install required mongod based on OM version
    mdb_ver=$(echo "7.0.8" | awk -F'.' '{print $1"."$2}')
    echo "Installing appDB with MongoDB version $mdb_ver-ent. Minor version will stable release of $mdb_ver"
    echo "**********Staring Logs from m**********"
    yes | m "$mdb_ver-ent" > .moutput.txt

    echo "**********END log from m**********"

    copy_binaires

    # # extracting some values with text manipulation
    # awk '{printf "%s", $0}' .moutput.txt > .fixedmoutput.txt
    # mdb_ver=$(awk -F 'MongoDB Server ' '{print $2}' "./.fixedmoutput.txt" | awk -F ', ' '{print $1}')
    # #bin_path=$(awk -F 'Installation to ' '{print $2}' "./.fixedmoutput.txt" | awk -F ' complete' '{print $1}')
    # bin_path=$(m bin $mdb_ver)
    # rm ./.moutput.txt ./.fixedmoutput.txt # quick cleanups
    echo "value of version is $mdb_ver and value of bin_path is $bin_path"



    echo "****************"
    # Check if dbPath exists
    echo "Checking for existing $dbPath"
    if [ -d "$dbPath" ]; then
        echo "$dbPath already exists. WARNING: Directory contents may be cleared" 2>&1
    else
        echo "$dbPath does not to exist. Creating $dbPath"
        sudo mkdir -p "$dbPath"
        echo "created dbPath: $(ls -d $dbPath 2>&1)"
        echo "dbPath for appDB will be set to $dbPath"
    fi
    echo "****************"
    ## check if mongod user exists
    echo "****************"
    echo "Cheking for required users"

    user_check=$(egrep -i "mongod" /etc/passwd | awk -F':' '{print $1}')
    group_check=$(egrep -i "mongod" /etc/group | awk -F':' '{print $1}')

    ## check if mongod user is already created
    if [ "$user_check" = "mongod" ]; then
        echo "Existing mongod user was found. Skipping step"
    else
        echo "Creating mongod user"
        sudo useradd mongod
        echo "mongod user has been successfully created"
    fi

    # check if mongod group is already created
    if [ "$group_check" = "mongod" ] ; then
        echo "mongod group exists"
    else
        echo "Creating mongod group"
        sudo groupmod mongod
        echo "mongod group has been successfully created"
    fi
    
    # check if mongod user is part of mongod group
    if [ $(groups mongod | awk -F' ' '{print $3}') = "mongod" ] ; then
        echo "mongod user is already part of mongod group. Skipping step"
    else
        echo "Adding mongod user to mongod group"
        sudo usermod -aG mongod mongod
        echo "mongod user has been added to mongod group"

    fi
    echo "****************"
    echo "****************"
    #create mongod user and group. Add mongod user to mongod group
    echo "Updating $dbPath ownership"
    sudo chown -R mongod:mongod $dbPath
    echo "$dbPath ownership has been updated to mongod:mongod"
    echo "****************"

    : > .mongod.conf # clearing existing mongod.conf contents if any

    ### create conf file and populate it
echo "$APPDB_PORT"
    local existing_binaries=$(ls /etc/mongod.conf)
    if [ -z "$existing_binaries" ]; then
        echo "******** START:SETTING UP MONGOD.CONF FILE ********"
        cat <<EOF >> .mongod.conf
### simple mongod.conf 
systemLog:
  destination: file
  path: "/data/mongodb.log"
  logAppend: true
storage:
  dbPath: "/data"
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
processManagement:
  fork: true
#timeZoneInfo: /usr/share/zoneinfo
#pidFilePath: /var/run/mongodb/mongod.pid
net:
  bindIp: 0.0.0.0
  port: $APPDB_PORT
EOF

        echo "Adding mongod.conf to /etc/mongod.conf"
        sudo cp ./.mongod.conf /etc/mongod.conf

        echo "created mongod.conf in /etc/mongod.conf"
        echo "******** END: SETTING UP MONGOD.CONF FILE ********"
    else
        echo "/etc/mongod.conf already exists"
    fi




}

startup_appdb() {
    #local APPDB_PORT=27017
    local pid=$(sudo lsof -t -i :"$APPDB_PORT")

    if [ -z "$pid" ]; then
        echo "Starting up mongod process with version $mdb_ver as mongod user"
        sudo -u mongod mongod -f /etc/mongod.conf
    else
        echo "PORT $APPDB_PORT is currently in use. Unable to startup mongod for appdb on port $APPDB_PORT"
    fi

}

