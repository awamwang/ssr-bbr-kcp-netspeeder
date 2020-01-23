# SSR-BBR-KCP-NETSPEEDER

## Quick Start

```shell
docker run --privileged -d \
-p 12345:12345 \
-p 23456:23456/tcp \
-p 23456:23456/udp \
-e SS_PORT=12345 \
-e SS_PASSWORD=ss-passwd \
-e SS_METHOD=rc4-md5 \
-e SS_PROTOCOL=origin \
-e SS_OBFS=plain \
-e NO_KCP=F \
-e KCPTUN_CONF="/app/data/kcptun_config.json" \
-e KCPTUN_LISTEN=23456 \
-e KCPTUN_SS_LISTEN=34567 \
-e KCPTUN_SOCKS5_PORT=12345 \
-e KCPTUN_KEY=kcp-passwd \
-e KCPTUN_CRYPT=aes-128 \
-e KCPTUN_MODE=fast3 \
-e KCPTUN_MTU=1350 \
-e KCPTUN_SNDWND=512 \
-e KCPTUN_RCVWND=512 \
-e KCPTUN_NOCOMP=false \
wangnew2013/ssr-bbr-kcp-netspeeder --restart always
```

Keep the Docker container running automatically after starting, add **--restart always**.

## Use env to config

```shell
ENV SS_PORT="12345" \
    SS_PASSWORD="ssr-passwd" \
    SS_METHOD="none" \
    SS_PROTOCOL="auth_chain_a" \
    SS_OBFS="tls1.2_ticket_auth" \
    NO_KCP="F" \
    KCPTUN_CONF="/app/data/kcptun_config.json" \
    KCPTUN_LISTEN=45678 \
    KCPTUN_SS_LISTEN=34567 \
    KCPTUN_SOCKS5_PORT=12345 \
    KCPTUN_KEY=password \
    KCPTUN_CRYPT=aes \
    KCPTUN_MODE=fast2 \
    KCPTUN_MTU=1350 \
    KCPTUN_SNDWND=1024 \
    KCPTUN_RCVWND=1024 \
    KCPTUN_NOCOMP=false
```

### More

[ssr-bbr-docker](https://hub.docker.com/r/letssudormrf/ssr-bbr-docker)

[kcptun-socks5-ss-server-docker](https://hub.docker.com/r/caidaoli/kcptun-socks5-ss-server-docker)
