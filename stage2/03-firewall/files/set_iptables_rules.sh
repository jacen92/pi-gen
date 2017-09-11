#!/bin/sh

# source: https://www.alsacreations.com/tuto/lire/622-Securite-firewall-iptables.html
# BASIC RULES, DO NOT EDIT HERE (prefer 00-run.sh)
# flush current tables
iptables -t filter -F

# flush personnal tables
iptables -t filter -X

# All connections are forbidden
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP

# ---------------------------------------------------------------

# Keep ESTABLISHED connections
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow loopback connections
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT

# Allow ICMP (Ping)
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT

# ---------------------------------------------------------------

# Allow DNS In/Out (domain names)
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT

# Allow NTP Out (date)
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT

# Allow apt-get OUTPUT (use http)
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT

# Allow rpi-update OUTPUT (use https)
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
# ---------------------------------------------------------------
