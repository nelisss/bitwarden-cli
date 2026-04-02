#!/bin/bash

set -e

BW_UID=${BW_UID:-1000}
BW_GID=${BW_GID:-1000}
BW_SERVER=${BW_SERVER}
BW_CLIENTID=${BW_CLIENTID}
BW_CLIENTSECRET=${BW_CLIENTSECRET}

if [[ "${BW_CLIENTID}" == "" ]]; then
    echo "Error: BW_CLIENTID env variable should be set."
    exit 1
elif [[ "${BW_CLIENTSECRET}" == "" ]]; then
    echo "Error: BW_CLIENTSECRET env variable should be set."
    exit 1
fi

groupadd -f -g ${BW_GID} bitwarden
useradd -u ${BW_UID} -g ${BW_GID} -s /bin/bash bitwarden
chown -R ${BW_UID}:${BW_GID} /home/bitwarden

gosu bitwarden bash -c 'if [[ "${BW_SERVER}" != "" ]]; then bw config server ${BW_SERVER}; fi'
gosu bitwarden bw login --apikey

exec gosu bitwarden "$@"
