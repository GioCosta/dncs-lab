export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip addr add 192.168.1.254/23 dev enp0s8
ip addr add 192.168.5.254/23 dev enp0s8
ip addr add 192.168.255.253/30 dev enp0s9
ip link set enp0s8 up
ip link set enp0s9 up
ip route add 172.16.0.0/24 via 192.168.255.254 dev enp0s9
sysctl net.ipv4.ip_forward=1