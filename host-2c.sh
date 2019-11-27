export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip link set dev enp0s8 up
ip addr add 192.168.6.1/24 dev enp0s8
ip route add 192.168.0.0/16 via 192.168.6.254 dev enp0s8