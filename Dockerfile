FROM ubuntu:24.04
LABEL authors="brianvo"
LABEL description="Network debugging toolkit with DNS, HTTP, TCP, UDP, SSL/TLS tools"

ENV DEBIAN_FRONTEND=noninteractive

# Install all network debugging tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Network capture and analysis
    tcpdump \
    tshark \
    ngrep \
    tcpflow \
    # HTTP/HTTPS tools
    curl \
    wget \
    apache2-utils \
    # SSL/TLS tools
    openssl \
    gnutls-bin \
    # Network utilities
    net-tools \
    iproute2 \
    iputils-ping \
    iputils-tracepath \
    traceroute \
    netcat-openbsd \
    telnet \
    nmap \
    iftop \
    ethtool \
    # Text processing
    vim-tiny \
    nano \
    less \
    jq \
    # System tools
    strace \
    lsof \
    htop \
    procps \
    psmisc \
    # Python
    python3-minimal \
    python3-pip \
    ca-certificates \
    git \
    # Additional tools
    dnsmasq-base \
    hping3 \
    netsniff-ng \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install oh-my-bash
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
# Configure oh-my-bash theme
RUN sed -i 's/^OSH_THEME=.*/OSH_THEME="powerline"/' /root/.bashrc

# Install Python packages for advanced debugging
RUN pip3 install --no-cache-dir --break-system-packages \
    httpx \
    requests \
    dnspython \
    scapy

# Vim config
COPY .vimrc /root/.vimrc

# Create working directories
RUN mkdir -p /debug/{logs,captures,ssl-certs}

# Print installed tools
RUN echo '#!/bin/bash\n\
echo "=== INSTALLED NETWORK DEBUG TOOLS ==="\n\
echo ""\n\
echo "DNS Tools:"\n\
echo "  - dig (dnsutils)"\n\
echo "  - nslookup (dnsutils)"\n\
echo "  - dnsmasq"\n\
echo ""\n\
echo "Packet Capture & Analysis:"\n\
echo "  - tcpdump"\n\
echo "  - tshark (Wireshark CLI)"\n\
echo "  - ngrep (network grep)"\n\
echo "  - tcpflow"\n\
echo "  - netsniff-ng"\n\
echo ""\n\
echo "HTTP/HTTPS Tools:"\n\
echo "  - curl"\n\
echo "  - wget"\n\
echo "  - ab (Apache Benchmark)"\n\
echo "  - httpx (Python)"\n\
echo "  - requests (Python)"\n\
echo ""\n\
echo "SSL/TLS Tools:"\n\
echo "  - openssl"\n\
echo "  - gnutls-cli"\n\
echo ""\n\
echo "TCP/UDP Tools:"\n\
echo "  - nc (netcat)"\n\
echo "  - telnet"\n\
echo "  - hping3"\n\
echo ""\n\
echo "Network Scanning:"\n\
echo "  - nmap"\n\
echo ""\n\
echo "Network Monitoring:"\n\
echo "  - iftop (bandwidth)"\n\
echo "  - mtr (traceroute + ping)"\n\
echo ""\n\
echo "Network Utilities:"\n\
echo "  - ip (iproute2)"\n\
echo "  - ifconfig (net-tools)"\n\
echo "  - netstat (net-tools)"\n\
echo "  - ss (iproute2)"\n\
echo "  - ping"\n\
echo "  - traceroute"\n\
echo "  - tracepath"\n\
echo "  - ethtool"\n\
echo ""\n\
echo "Python Libraries:"\n\
echo "  - scapy (packet manipulation)"\n\
echo "  - dnspython (DNS toolkit)"\n\
echo ""\n\
echo "System Tools:"\n\
echo "  - strace (system call tracer)"\n\
echo "  - lsof (list open files)"\n\
echo "  - htop (process monitor)"\n\
echo ""\n\
echo "Text Processing:"\n\
echo "  - jq (JSON processor)"\n\
echo "  - grep"\n\
echo "  - vim, nano, less"\n\
echo ""\n\
echo "Working Directory: /debug"\n\
' > /usr/local/bin/tools-list && chmod +x /usr/local/bin/tools-list

WORKDIR /debug

CMD ["bash", "-c", "tools-list && exec bash"]