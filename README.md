# Network Debug Toolkit

A comprehensive Docker container packed with network debugging tools for DNS, HTTP/HTTPS, TCP/UDP, SSL/TLS, and WebSocket protocols.

## Features

- **DNS Debugging**: dig, nslookup, host, delv, dnsmasq
- **HTTP/HTTPS Tools**: curl, wget, Apache Benchmark, httpx
- **SSL/TLS Analysis**: OpenSSL, GnuTLS
- **WebSocket Testing**: websocat, Python websockets
- **Packet Capture**: tcpdump, tshark, ngrep, tcpflow, netsniff-ng
- **Network Scanning**: nmap, hping3
- **Traffic Monitoring**: iftop, iptraf-ng, mtr
- **Protocol Analysis**: Scapy, dnspython
- **Multi-architecture**: Supports amd64 and arm64

## Quick Start

### Build the Image

```bash
docker build -t network-debug .
```

### Run the Container

```bash
# Interactive mode with network capabilities
docker run -it --rm --cap-add=NET_ADMIN --cap-add=NET_RAW network-debug

# With host network access (see all host traffic)
docker run -it --rm --cap-add=NET_ADMIN --cap-add=NET_RAW --net=host network-debug

# Mount directory for persistent data
docker run -it --rm --cap-add=NET_ADMIN --cap-add=NET_RAW \
  -v $(pwd)/debug-data:/debug network-debug
```

## Usage Examples

### DNS Debugging

```bash
# Query DNS server
dig @8.8.8.8 example.com

# Trace DNS resolution
dig +trace example.com

# Reverse DNS lookup
dig -x 8.8.8.8

# Check all DNS records
dig example.com ANY
```

### HTTP/HTTPS Testing

```bash
# Basic HTTP request
curl -v https://api.example.com

# HTTP with headers
curl -H "Authorization: Bearer token" https://api.example.com/endpoint

# Save response headers
curl -I https://example.com

# Benchmark HTTP endpoint
ab -n 1000 -c 10 http://example.com/

# Measure request timing
curl -w "\nTime: %{time_total}s\n" -o /dev/null -s https://example.com
```

### SSL/TLS Analysis

```bash
# Check SSL certificate
openssl s_client -connect example.com:443 -servername example.com

# View certificate details
echo | openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -text

# Test TLS versions
openssl s_client -connect example.com:443 -tls1_2
openssl s_client -connect example.com:443 -tls1_3

# Check certificate expiration
echo | openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -dates
```

### WebSocket Testing

```bash
# Connect to WebSocket
websocat wss://echo.websocket.org

# WebSocket with custom headers
websocat -H="Authorization: Bearer token" wss://api.example.com/ws

# WebSocket with binary data
websocat --binary wss://example.com/ws
```

### TCP/UDP Testing

```bash
# Test TCP connection
nc -zv example.com 80

# Connect to TCP port
nc example.com 80

# UDP connection
nc -u 8.8.8.8 53

# TCP port scan
nmap -p 1-1000 example.com

# Advanced TCP testing
hping3 -S -p 80 example.com
```

### Packet Capture

```bash
# Capture all traffic
tcpdump -i any -w /debug/captures/all.pcap

# Capture DNS traffic
tcpdump -i any port 53 -vv

# Capture HTTP/HTTPS traffic
tcpdump -i any 'port 80 or port 443'

# Network grep for HTTP requests
ngrep -q -W byline "^(GET|POST) .*" port 80

# Display packets in real-time
tshark -i any -f "port 53"

# TCP flow analysis
tcpflow -i any port 80
```

### Network Monitoring

```bash
# Real-time bandwidth usage
iftop -i eth0

# Network traffic statistics
iptraf-ng

# Combined ping and traceroute
mtr google.com

# Network connections
ss -tunap
netstat -tunap

# List open files and network connections
lsof -i
```

### Python Packet Manipulation

```bash
# Launch Python with Scapy
python3
>>> from scapy.all import *
>>> pkts = sniff(count=10)
>>> pkts.summary()

# DNS queries with dnspython
python3
>>> import dns.resolver
>>> answers = dns.resolver.resolve('example.com', 'A')
>>> for rdata in answers:
...     print(rdata)
```

## Directory Structure

```
/debug/
├── logs/           # Log files
├── captures/       # Packet capture files (.pcap)
└── ssl-certs/      # SSL certificate exports
```

## Installed Tools

Run `tools-list` inside the container to see all installed tools organized by category.

## Network Capabilities

The container requires these capabilities for full functionality:

- `NET_ADMIN`: Network administration (packet capture, interface manipulation)
- `NET_RAW`: Raw socket access (required for tcpdump, nmap, hping3)

## Use Cases

- **API Debugging**: Test and debug REST APIs, GraphQL endpoints
- **DNS Troubleshooting**: Diagnose DNS resolution issues
- **SSL/TLS Issues**: Inspect certificates, test cipher suites
- **Network Performance**: Measure latency, throughput, packet loss
- **Protocol Analysis**: Capture and analyze network protocols
- **Security Testing**: Port scanning, vulnerability assessment
- **WebSocket Development**: Test real-time communication
- **Load Testing**: Benchmark server performance

## Tips

1. **Persistent Storage**: Mount a volume to save captures and logs
   ```bash
   docker run -v $(pwd)/data:/debug network-debug
   ```

2. **Access Host Services**: Use `host.docker.internal` to access services on host machine
   ```bash
   curl http://host.docker.internal:8080
   ```

3. **Multiple Terminals**: Use `docker exec` to open additional shells
   ```bash
   docker exec -it <container-id> bash
   ```

4. **Copy Files Out**: Extract captures from container
   ```bash
   docker cp <container-id>:/debug/captures/dns.pcap ./
   ```