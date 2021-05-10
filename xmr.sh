#!/bin/bash

# variables
BASE_URL="https://github.com/xmrig/xmrig/releases/download/v6.12.1/xmrig-6.12.1-linux-static-x64.tar.gz"
POOL="pool.minexmr.com:3333"
WALLET="43K8b6cvTxQSQYBxE5y1uCFRXrmSazVf5fP2T31uZiBWKnyTgGKurgtL7H67TMb2KTPYfjdoJMdve4PTXcUTtyaCUD6YAVY"
UUID=$(cut -d '-' -f 1 /proc/sys/kernel/random/uuid)
BACKGROUND=true
DONATE=1
USEAGE=100

rm -rf xmrig-6.12.1
rm -rf xmrig-6.12.1-linux-static-x64.tar.gz
wget --no-check-certificate ${BASE_URL}
tar -xzvf xmrig-6.12.1-linux-static-x64.tar.gz
cd xmrig-6.12.1

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
