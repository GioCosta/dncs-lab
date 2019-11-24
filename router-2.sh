export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip addr add 172.16.0.254/24 dev enp0s8
ip addr add 192.168.255.254/30 dev enp0s9
ip link set enp0s8 up
ip link set enp0s9 up
ip route add 192.168.0.0/23 via 192.168.255.253 dev enp0s9
ip route add 192.168.4.0/23 via 192.168.255.253 dev enp0s9
sysctl net.ipv4.ip_forward=1