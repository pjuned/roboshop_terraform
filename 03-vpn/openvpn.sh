#!/bin/bash
set -euxo pipefail

LOG=/var/log/openvpn-userdata.log
exec > >(tee -a $LOG) 2>&1

# ---------- Enable IP forwarding ----------
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# ---------- Get Public IP (IMDSv2) ----------
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

ENDPOINT=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

# ---------- Download installer ----------
cd /root
curl -fsSL https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh -o openvpn-install.sh
chmod +x openvpn-install.sh

# ---------- Install OpenVPN (EXPLICIT) ----------
AUTO_INSTALL=y \
APPROVE_INSTALL=y \
APPROVE_IP=y \
IPV6_SUPPORT=n \
PORT_CHOICE=1 \
PROTOCOL_CHOICE=2 \
DNS=1 \
COMPRESSION_ENABLED=n \
CUSTOMIZE_ENC=n \
ENDPOINT=$ENDPOINT \
./openvpn-install.sh install

# ---------- Create client ----------
CLIENT=junaid PASS=1 ./openvpn-install.sh client add

# ---------- NAT ----------
IFACE=$(ip route get 8.8.8.8 | awk '{print $5; exit}')
iptables -t nat -A POSTROUTING -o "$IFACE" -j MASQUERADE
iptables-save > /etc/sysconfig/iptables


