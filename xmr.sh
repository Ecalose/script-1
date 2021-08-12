#!/bin/bash

# variables
BASE_URL="https://github.com/xmrig/xmrig/releases/download/v6.14.0/xmrig-6.14.0-linux-static-x64.tar.gz"
POOL="pool.minexmr.com:3333"
WALLET=""
UUID=$(cut -d '-' -f 1 /proc/sys/kernel/random/uuid)
BACKGROUND=true
DONATE=0
USEAGE=100

# get options
while [[ $# -ge 1 ]]; do
    case $1 in
    -b | --background)
        shift
        BACKGROUND="$1"
        shift
        ;;
    -d | --donate)
        shift
        DONATE="$1"
        shift
        ;;
    -p | --pool)
        shift
        POOL="$1"
        shift
        ;;
    -u | --useage)
        shift
        USEAGE="$1"
        shift
        ;;
    -w | --worker)
        shift
        WALLET="$1"
        shift
        ;;
    *)
        if [[ "$1" != 'error' ]]; then
            echo -ne "\nInvaild option: '$1'\n\n"
        fi
        exit 1
        ;;
    esac
done

rm -rf xmrig-6.14.0
rm -rf xmrig-6.14.0-linux-static-x64.tar.gz
wget --no-check-certificate ${BASE_URL}
tar -xzvf xmrig-6.14.0-linux-static-x64.tar.gz
cd xmrig-6.14.0

# prepare config
rm -f config.json
cat > config.json << EOF
{
    "autosave": true,
    "background": ${BACKGROUND},
    "randomx": {
        "1gb-pages": true
    },
    "donate-level": ${DONATE},
    "cpu": {
        "enabled": true,
        "max-threads-hint": ${USEAGE}
    },
    "opencl": false,
    "cuda": false,
    "pools": [
        {
            "coin": null,
            "algo": null,
            "url": "${POOL}",
            "user": "${WALLET}+100000.${UUID}",
            "rig-id": "${UUID}",
            "pass": "x",
            "tls": false,
            "keepalive": true,
            "nicehash": false
        }
    ]
}
EOF

# load service
./xmrig
