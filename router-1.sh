export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common
ip link add link enp0s8 name enp0s8.10 type vlan id 10
ip link add link enp0s8 name enp0s8.20 type vlan id 20
ip addr add 192.168.1.254/23 dev enp0s8.10 
ip addr add 192.168.3.254/23 dev enp0s8.20 
ip addr add 192.168.255.253/30 dev enp0s9
ip link set enp0s8 up
ip link set enp0s8.10 up
ip link set enp0s8.20 up
ip link set enp0s9 up
sysctl net.ipv4.ip_forward=1