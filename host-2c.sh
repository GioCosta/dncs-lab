export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common
ip addr add 172.16.0.1/24 dev enp0s8
ip link set enp0s8 up
ip route replace 172.16.0.0/16 via 172.16.0.254