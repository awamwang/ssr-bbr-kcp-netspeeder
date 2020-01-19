# SSR-BBR-KCP-NETSPEEDER

## Quick Start

```shell
docker run --privileged -d ssr-bbr-kcp-netspeeder
```

Keep the Docker container running automatically after starting, add **--restart always**.

## Use env to config

```shell
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
```

### More

[ssr-bbr-docker](https://hub.docker.com/r/letssudormrf/ssr-bbr-docker)

[kcptun-socks5-ss-server-docker](https://hub.docker.com/r/caidaoli/kcptun-socks5-ss-server-docker)
