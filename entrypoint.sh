#!/bin/bash

set -e

BW_UID=${BW_UID:-1000}
BW_GID=${BW_GID:-1000}
BW_SERVER=${BW_SERVER}
BW_CLIENTID=${BW_CLIENTID}
BW_CLIENTSECRET=${BW_CLIENTSECRET}
BW_MASTERPASSWORD=${BW_MASTERPASSWORD}

if [[ "${BW_CLIENTID}" == "" ]]; then
    echo "Error: BW_CLIENTID env variable should be set."
    exit 1
elif [[ "${BW_CLIENTSECRET}" == "" ]]; then
    echo "Error: BW_CLIENTSECRET env variable should be set."
    exit 1
elif [[ "${BW_MASTERPASSWORD}" == "" ]]; then
    echo "Error: BW_MASTERPASSWORD env variable should be set."
    exit 1
fi

if ( cat /etc/issue | grep "Debian" > /dev/null ); then
    groupadd -f -g ${BW_GID} bitwarden
    useradd -u ${BW_UID} -g ${BW_GID} -s /bin/bash bitwarden
else
    addgroup --gid ${BW_GID} bitwarden
    adduser -D -u ${BW_UID} -G bitwarden -s /bin/bash bitwarden
fi
chown -R ${BW_UID}:${BW_GID} /home/bitwarden

gosu bitwarden bash -c 'if [[ "${BW_SERVER}" != "" ]]; then bw config server ${BW_SERVER}; fi'
gosu bitwarden bw login --apikey
export BW_SESSION=$( bw unlock --passwordenv BW_MASTERPASSWORD | grep -oP -m 1 '(?<=BW_SESSION=").*==(?=")' )

exec gosu bitwarden "$@"
