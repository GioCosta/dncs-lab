export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip link add link enp0s8 name enp0s8.100 type vlan id 100
ip link add link enp0s8 name enp0s8.200 type vlan id 200
ip link set dev enp0s8 up
ip link set dev enp0s8.100 up
ip link set dev enp0s8.200 up
ip link set dev enp0s9 up
ip addr add 192.168.1.254/23 dev enp0s8.100
ip addr add 192.168.3.254/23 dev enp0s8.200
ip addr add 192.168.5.1/30 dev enp0s9
ip route add 192.168.4.0/24 via 192.168.5.2 dev enp0s9
sysctl net.ipv4.ip_forward=1