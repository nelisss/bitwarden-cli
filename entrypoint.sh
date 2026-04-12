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
fi

if ( cat /etc/group | grep -E "^bitwarden:" > /dev/null ); then
    if ( ! cat /etc/group | grep "bitwarden:x:${BW_GID}" > /dev/null ); then
        echo "Group bitwarden exists with different GID: changing GID"
        groupmod -g ${BW_GID} bitwarden
    fi
else
    if ( cat /etc/issue | grep "Debian" > /dev/null ); then
        groupadd -g ${BW_GID} bitwarden
    else
        addgroup --gid ${BW_GID} bitwarden
    fi
fi
if ( cat /etc/passwd | grep -E "^bitwarden:" > /dev/null); then
    if ( ! cat /etc/passwd | grep "bitwarden:x:${BW_UID}:${BW_GID}" > /dev/null); then
        echo "User bitwarden exists with different UID or GID: changing UID/GID"
        usermod -u ${BW_UID} bitwarden
        groupmod -g ${BW_GID} bitwarden
    fi
else
    if ( cat /etc/issue | grep "Debian" > /dev/null ); then
        useradd -u ${BW_UID} -g ${BW_GID} -s /bin/bash bitwarden
    else
        adduser -D -u ${BW_UID} -G bitwarden -s /bin/bash bitwarden
    fi
fi

chown -R ${BW_UID}:${BW_GID} /home/bitwarden

if ( ! gosu bitwarden bw status | grep 'status":"unauthenticated' > /dev/null ); then
    gosu bitwarden bw logout
fi
if [[ "${BW_SERVER}" != "" ]]; then 
    gosu bitwarden bw config server ${BW_SERVER}
fi
gosu bitwarden bw login --apikey

if [[ "${BW_MASTERPASSWORD}" != "" ]]; then
    export $( gosu bitwarden bw unlock --passwordenv BW_MASTERPASSWORD | grep -oE -m 1 'BW_SESSION=(.*==)"' | sed 's/"//g' )
fi

exec gosu bitwarden "$@"
