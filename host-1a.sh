export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip addr add 192.168.0.1/23 dev enp0s8
ip link set enp0s8 up
ip route add 172.16.0.0/24 via 192.168.1.254 dev enp0s8
#ip route add 192.168.4.0/23 via 192.168.1.254 dev enp0s8