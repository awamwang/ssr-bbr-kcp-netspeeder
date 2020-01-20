#!/bin/sh

# kcptun
if [ $NO_KCP = "F" ]; then
        exec /app/kcptun/kcptun-start.sh > /app/data/kcptun.log 2>&1 &
fi

cd shadowsocksr \
        && rm mudb.json \
        && python /app/shadowsocksr/mujson_mgr.py -a -u MUDB -p ${SS_PORT} -k ${SS_PASSWORD} -m ${SS_METHOD} -O ${SS_PROTOCOL} -o ${SS_OBFS} -G "#" > /app/data/ss-config.log 2>&1
# ssr+bbr
if [ $# -gt 0 ];
then
        while getopts "p:k:m:O:o:" arg;
                do
                        case $arg in
                                p)
                                        sed -i "3,12s/^.*\"port\":.*$/        \"port\": ${OPTARG},/" /app/shadowsocksr/mudb.json
                                ;;
                                k)
                                        sed -i "3,12s/^.*\"passwd\":.*$/        \"passwd\": \"${OPTARG}\",/" /app/shadowsocksr/mudb.json
                                ;;
                                m)
                                        sed -i "3,12s/^.*\"method\":.*$/        \"method\": \"${OPTARG}\",/" /app/shadowsocksr/mudb.json
                                ;;
                                O)
                                        sed -i "3,12s/^.*\"protocol\":.*$/        \"protocol\": \"${OPTARG}\",/" /app/shadowsocksr/mudb.json
                                ;;
                                o)
                                        sed -i "3,12s/^.*\"obfs\":.*$/        \"obfs\": \"${OPTARG}\",/" /app/shadowsocksr/mudb.json
                                ;;
                        esac
                done
fi
cp /app/shadowsocksr/mudb.json /app/data/mudb.json
cat /app/data/mudb.json | awk '$1=="\"port\":" {print $NF+0}' | awk '$NF<=65535' > /app/data/mudb_port.txt

echo -n "" > /app/ssr-bbr/rinetd.conf
while read line
do
        echo "0.0.0.0 $line 0.0.0.0 $line" >> /app/ssr-bbr/rinetd.conf
done < /app/data/mudb_port.txt

/app/ssr-bbr/rinetd_bbr_powered -f -c /app/ssr-bbr/rinetd.conf raw eth0 &
python /app/shadowsocksr/server.py m>> /app/data/ssserver.log 2>&1	
