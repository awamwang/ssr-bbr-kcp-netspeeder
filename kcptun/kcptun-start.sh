#!/bin/bash
#########################################################################
# File Name: kcptun-server.sh
# Version:1.0.0
# Created Time: 2020-01-15
#########################################################################

set -e
RUNENV=${RUNENV:-kcptunsocks-kcptunss}                        #"RUNENV": kcptunsocks-kcptunss, kcptunsocks, kcptunss, ss
KCPTUN_CONF=${KCPTUN_CONF:-/app/data/kcptun_config.json}

# ======= KCPTUN CONFIG ======
KCPTUN_LISTEN=${KCPTUN_LISTEN:-45678}                         #"listen": ":45678",
KCPTUN_SS_LISTEN=${KCPTUN_SS_LISTEN:-34567}                   #"listen": ":45678", kcptun for ss listen port
KCPTUN_SOCKS5_PORT=${KCPTUN_SOCKS5_PORT:-12948}               #"socks_port": 12948,
KCPTUN_KEY=${KCPTUN_KEY:-password}                            #"key": "password",
KCPTUN_CRYPT=${KCPTUN_CRYPT:-aes}                             #"crypt": "aes",
KCPTUN_MODE=${KCPTUN_MODE:-fast2}                             #"mode": "fast2",
KCPTUN_MTU=${KCPTUN_MTU:-1350}                                #"mtu": 1350,
KCPTUN_SNDWND=${KCPTUN_SNDWND:-1024}                          #"sndwnd": 1024,
KCPTUN_RCVWND=${KCPTUN_RCVWND:-1024}                          #"rcvwnd": 1024,
KCPTUN_NOCOMP=${KCPTUN_NOCOMP:-false}                         #"nocomp": false


[ ! -f ${KCPTUN_CONF} ] && cat > ${KCPTUN_CONF}<<-EOF
{
    "listen": ":${KCPTUN_LISTEN}",
    "target": "127.0.0.1:${KCPTUN_SOCKS5_PORT}",
    "key": "${KCPTUN_KEY}",
    "crypt": "${KCPTUN_CRYPT}",
    "mode": "${KCPTUN_MODE}",
    "mtu": ${KCPTUN_MTU},
    "sndwnd": ${KCPTUN_SNDWND},
    "rcvwnd": ${KCPTUN_RCVWND},
    "nocomp": false
}
EOF

kcptun_nocomp_flag=""
if [[ "${KCPTUN_NOCOMP}" =~ ^[Tt][Rr][Uu][Ee]|[Yy][Ee][Ss]|[Yy]|1|[Ee][Nn][Aa][Bb][Ll][Ee]$ ]]; then
    sed -ri "s/(\"nocomp\":).*/\1 true/" ${KCPTUN_CONF}
    kcptun_nocomp_flag=" --nocomp"
fi

echo "+---------------------------------------------------------+"
echo "|   Manager for Kcptun-Socks5 & Kcptun-Shadowsocks-libev  |"
echo "+---------------------------------------------------------+"
echo "|     Images: cndocker/kcptun-socks5-ss-server:latest     |"
echo "+---------------------------------------------------------+"
echo "|         Intro: https://github.com/cndocker              |"
echo "+---------------------------------------------------------+"
echo ""

# kcptun
kcp-server -v
exec "kcp-server" -c ${KCPTUN_CONF}

