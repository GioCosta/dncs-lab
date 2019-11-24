export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip addr add 172.16.0.1/24 dev enp0s8
ip link set enp0s8 up
ip route add 192.168.0.0/23 via 172.16.0.254 dev enp0s8
ip route add 192.168.4.0/23 via 172.16.0.254 dev enp0s8