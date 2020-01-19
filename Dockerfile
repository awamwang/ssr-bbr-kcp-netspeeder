FROM debian:stretch

MAINTAINER awamwang

# deps
# RUN cat /etc/apt/sources.list
COPY superupdate.sh /app/
RUN bash /app/superupdate.sh aliyun

RUN apt-get update \
    && apt-get install -y wget curl libsodium-dev python git ca-certificates iptables --no-install-recommends

WORKDIR /app

#####################
# ssr+bbr
#####################
# config ssr-mudb
ENV SS_PORT="12948" \
    SS_PASSWORD="ssr-passwd" \
    SS_METHOD="none" \
    SS_PROTOCOL="auth_chain_a" \
    SS_OBFS="tls1.2_ticket_auth" \
    NO_KCP="F" \
    KCPTUN_CONF="/app/data/kcptun_config.json" \
	KCPTUN_LISTEN=45678 \
	KCPTUN_SS_LISTEN=34567 \
	KCPTUN_SOCKS5_PORT=12948 \
	KCPTUN_KEY=password \
	KCPTUN_CRYPT=aes \
	KCPTUN_MODE=fast2 \
	KCPTUN_MTU=1350 \
	KCPTUN_SNDWND=1024 \
	KCPTUN_RCVWND=1024 \
	KCPTUN_NOCOMP=false

# get shadowsocksr
RUN git clone -b akkariiin/master https://github.com/letssudormrf/shadowsocksr.git \
    && cd shadowsocksr \
    && bash initcfg.sh \
    && sed -i 's/sspanelv2/mudbjson/' userapiconfig.py \
    && python mujson_mgr.py -a -u MUDB -p ${SS_PORT} -k ${SS_PASSWORD} -m ${SS_METHOD} -O ${SS_PROTOCOL} -o ${SS_OBFS} -G "#"

# install
COPY /ssr-bbr/rinetd_bbr /ssr-bbr/rinetd_bbr_powered /ssr-bbr/rinetd_pcc /ssr-bbr/install.sh /app/ssr-bbr/
RUN chmod a+x /app/ssr-bbr/rinetd_bbr /app/ssr-bbr/rinetd_bbr_powered /app/ssr-bbr/rinetd_pcc /app/ssr-bbr/install.sh
RUN /app/ssr-bbr/install.sh

# data collection
RUN mkdir -p data

#####################
# kcptun
#####################
# 
ENV kcptun_latest="https://github.com/xtaci/kcptun/releases/latest" \
    KCPTUN_DIR=/usr/local/kcp-server

# RUN [ ! -d ${KCPTUN_DIR} ] && mkdir -p ${KCPTUN_DIR} && cd ${KCPTUN_DIR}
# COPY /kcptun/socks5_linux_amd64 ${KCPTUN_DIR}/socks5
RUN set -ex && \
	[ ! -d ${KCPTUN_DIR} ] && mkdir -p ${KCPTUN_DIR} && cd ${KCPTUN_DIR} \
	wget https://raw.githubusercontent.com/clangcn/kcp-server/master/socks5_latest/socks5_linux_amd64 -O ${KCPTUN_DIR}/socks5 && \
	kcptun_latest_release=`curl -s ${kcptun_latest} | cut -d\" -f2` && \
    kcptun_latest_download=`curl -s ${kcptun_latest} | cut -d\" -f2 | sed 's/tag/download/'` && \
    kcptun_latest_filename=`curl -s ${kcptun_latest_release} | sed -n '/text-bold">kcptun-linux-amd64/p' | cut -d">" -f2 | cut -d "<" -f1` && \
    wget ${kcptun_latest_download}/${kcptun_latest_filename} -O ${KCPTUN_DIR}/${kcptun_latest_filename} && \
    tar xzf ${KCPTUN_DIR}/${kcptun_latest_filename} -C ${KCPTUN_DIR}/ && \
    mv ${KCPTUN_DIR}/server_linux_amd64 ${KCPTUN_DIR}/kcp-server && \
    rm -f ${KCPTUN_DIR}/client_linux_amd64 ${KCPTUN_DIR}/${kcptun_latest_filename} && \
    chown root:root ${KCPTUN_DIR}/* && \
    chmod 755 ${KCPTUN_DIR}/* && \
    ln -s ${KCPTUN_DIR}/* /bin/

#####################
# bbr or serverspeeder
#####################
#RUN wget --no-check-certificate https://www.vrrmr.net/55R/rs_nh.sh && bash rs_nh.sh
#RUN wget -N --no-check-certificate https://github.com/91yun/serverspeeder/raw/master/serverspeeder.sh && bash serverspeeder.sh

#####################
# start
#####################
# SS_PORT
EXPOSE 34567 
# KCPTUN_LISTEN
EXPOSE 45678 

# kcptun
COPY /kcptun/kcptun-start.sh /app/kcptun/
RUN chmod a+x /app/kcptun/kcptun-start.sh

# entrypoint 
COPY start.sh /app/
RUN chmod a+x /app/start.sh
ENTRYPOINT ["/app/start.sh"]
CMD []
