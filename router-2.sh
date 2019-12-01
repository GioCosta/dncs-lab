export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip link set dev enp0s8 up
ip link set dev enp0s9 up
ip addr add 192.168.4.254/24 dev enp0s8
ip addr add 192.168.5.2/30 dev enp0s9
ip route add 192.168.0.0/16 via 192.168.5.1 dev enp0s9
sysctl net.ipv4.ip_forward=1