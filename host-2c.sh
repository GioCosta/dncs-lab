export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

ip link set dev enp0s8 up
ip addr add 192.168.4.1/24 dev enp0s8
ip route add 192.168.0.0/16 via 192.168.4.254 dev enp0s8

docker pull dustnic82/nginx-test:latest
docker run --name Test-docker -p 80:80 -d dustnic82/nginx-test:latest