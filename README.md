# DNCS-LAB
Design of Networks and Communication Systems, A.Y. 2019/20, University of Trento

Students:
- Matteo Strada, MAT: 214980
- Giovanni Costa, MAT: 188330

## Topology
This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |enp0s3
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |          enp0s3|            |enp0s9 enp0s9|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |enp0s8                     |enp0s8
        |  N  |                      |                           |
        |  A  |                      |                           |enp0s8
        |  G  |                      |                     +-----+----+
        |  E  |                      |enp0s8               |          |
        |  M  |            +-------------------+           |          |
        |  E  |      enp0s3|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |enp0s9       |enp0s10             |enp0s3
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |enp0s8       |enp0s8              |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |  enp0s3|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |enp0s3                 |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/dustnic/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of 

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 281 and 420 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 163 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/dustnic/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design
## Network configuration
### Subnets

As per assignment request, the network topology is divided in 4 different subnets:

| Subnet name |  Subnet address  |        Netmask       |         Devices        |
|:-----------:|:----------------:|:--------------------:|:----------------------:|
|      A      |  192.168.0.0/23  |  255.255.254.0 = 23  | *host-1-a*, *router-1* |
|      B      | 192.168.4.0/23   |  255.255.254.0 = 23  | *host-1-b*, *router-1* |
|      C      |  192.168.6.0/24  | 255.255.255.252 = 24 | *host-2-c*, *router-2* |
|      D      | 192.168.7.0/30   | 255.255.255.252 = 30 | *router-1*, *router-2* |


* Subnet **A** includes *host-1-a* and *router-1*. It has a */23* subnet mask to allow up to 2<sup>32-23</sup>-2= 510 hosts (assignment request was 281 hosts)
* Subnet **B** includes *host-1-b* and *router-1*. It has a */23* subnet mask to allow up to 2<sup>32-23</sup>-2= 510 hosts (assignment request was 420 hosts)
* Subnet **C** includes *router-2* and *host-2-c*. It has a */30* subnet mask to allow up to 2<sup>32-24</sup>-2= 254 hosts (assignment request was 163 hosts)
* Subnet **D** includes *router-1* and *router-2*. It has a */30* subnet mask to allow up to 2<sup>32-30</sup>-2= 2 hosts (subnet completely used)

### VLAN Setup
There is the need to use VLANs in order to two different subnets with the same interface of *router-1*. The VLAN IDs have been choosen as follows:
|  ID  |  Subnet  |
|:----:|:--------:|
| 100  |    A     |
| 200  |    B     | 

### IP interface setup

The IP assegnation summary for every interface:

|  Device  |  Interface  |     IP address     | Subnet |
|:--------:|:-----------:|:------------------:|:------:|
| host-1-a |    enp0s8   |   192.168.0.1/23   |    A   |
| router-1 | enp0s8.100  |  192.168.1.254/23  |    A   |
| host-1-b |    enp0s8   |   192.168.4.1/23   |    B   |
| router-1 | enp0s8.200  |  192.168.5.254/23  |    B   |
| router-2 |    enp0s8   |  192.168.6.254/24  |    C   |
| host-2-c |    enp0s8   |   192.168.6.1/24   |    C   |
| router-1 |    enp0s9   |   192.168.7.1/30   |    D   |
| router-2 |    enp0s9   |   192.168.7.2/30   |    D   |

# Vagrant VM Configuration
In the Vagrantfile each VM is created with the following example code:
```ruby
config.vm.define "machine-name" do |machine-name|
  ...
  ...
end
```

Vagrant is set up so that every device has its specific configuration script.
All devices are created with *bionic64* Vagrant box, and virtualbox as provider.

### Devices
#### Router 1
VM for *router-1* is created with the following code in the Vagrantfile:
```ruby
  config.vm.define "router-1" do |router1|
    router1.vm.box = "ubuntu/bionic64"
    router1.vm.hostname = "router-1"
    router1.vm.network "private_network", virtualbox__intnet: "broadcast_router-south-1", auto_config: false
    router1.vm.network "private_network", virtualbox__intnet: "broadcast_router-inter", auto_config: false
    router1.vm.provision "shell", path: "router-1.sh"
    router1.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *enp0s8* connected with *switch* device
* *enp0s9* connected with *router-2* device

After the creation of the VM, Vagrant will run *router-1.sh* provisioning script.
##### *Router 1* provisioning script
These lines create the two ports needed for the VLANs, namely with id 100 and 200:
```bash
ip link add link enp0s8 name enp0s8.100 type vlan id 100
ip link add link enp0s8 name enp0s8.200 type vlan id 200
```

These lines switch on the interfaces needed:
```bash
ip link set dev enp0s8 up
ip link set dev enp0s8.100 up
ip link set dev enp0s8.200 up
ip link set dev enp0s9 up
```

These lines are needed to assign the appropriate IP addresses to the interfaces:
```bash
ip addr add 192.168.1.254/23 dev enp0s8.100
ip addr add 192.168.5.254/23 dev enp0s8.200
ip addr add 192.168.7.1/30 dev enp0s9
```

These line is used to create a static route between *router-1* and *router-2* usign the interface enp0s9 with gateway 192.168.7.2:
```bash
ip route add 192.168.6.0/24 via 192.168.7.2 dev enp0s9
```

Finally this line abilitates the ip forwarding feature on *router-1*:
```bash
sysctl net.ipv4.ip_forward=1
```


#### Router 2
VM for *router-2* is created with the following code in the Vagrantfile:
```ruby
  config.vm.define "router-2" do |router2|
    router2.vm.box = "ubuntu/bionic64"
    router2.vm.hostname = "router-2"
    router2.vm.network "private_network", virtualbox__intnet: "broadcast_router-south-2", auto_config: false
    router2.vm.network "private_network", virtualbox__intnet: "broadcast_router-inter", auto_config: false
    router2.vm.provision "shell", path: "router-2.sh"
    router2.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *enp0s8* connected with *host-2c* device
* *enp0s9* connect with *router-1* device

After the creation of the VM, Vagrant will run *router-2.sh* provisioning script.
##### *Router 2* provisioning script
These lines switch on the interfaces needed:
```bash
ip link set dev enp0s8 up
ip link set dev enp0s9 up
```

These lines are needed to assign the appropriate IP addresses to the interfaces:
```bash
ip addr add 192.168.6.254/24 dev enp0s8
ip addr add 192.168.7.2/30 dev enp0s9
```

These line is used to create a static route between *router-2* and *router-1* usign the interface enp0s9 with gateway 192.168.7.1:
```bash
ip route add 192.168.0.0/16 via 192.168.7.1 dev enp0s9
```

Finally this line abilitates the ip forwarding feature on *router-2*:
```bash
sysctl net.ipv4.ip_forward=1
```

#### Host 1A
VM for *host-1a* is created with the following code in the Vagrantfile:
```ruby
  config.vm.define "host-a" do |hosta|
    hosta.vm.box = "ubuntu/bionic64"
    hosta.vm.hostname = "host-a"
    hosta.vm.network "private_network", virtualbox__intnet: "broadcast_host_a", auto_config: false
    hosta.vm.provision "shell", path: "host-1a.sh"
    hosta.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *enp0s8* connected with *switch* device

After the creation of the VM, Vagrant will run *host-1a.sh* provisioning script.
##### *Host 1A* provisioning script
This line switches on the interface needed:
```bash
ip link set dev enp0s8 up
```

This line assigns the appropriate IP address to the interface:
```bash
ip addr add 192.168.0.1/23 dev enp0s8
```

These line is used to create a static route between *host-a* and *router-1*, *router-2*, *host-c* usign the interface enp0s8 with gateway 192.168.1.254:
```bash
ip route add 192.168.6.0/23 via 192.168.1.254 dev enp0s8
```

This line is used to make communication between subnet A and B available. If someone wish to do so, the line before should be commented and this one uncommented:
```bash
# ip route add 192.168.0.0/16 via 192.168.1.254 dev enp0s8
```

#### Host 1B
VM for *host-1b* is created with the following code in the Vagrantfile:
```ruby
  config.vm.define "host-b" do |hostb|
    hostb.vm.box = "ubuntu/bionic64"
    hostb.vm.hostname = "host-b"
    hostb.vm.network "private_network", virtualbox__intnet: "broadcast_host_b", auto_config: false
    hostb.vm.provision "shell", path: "host-1b.sh"
    hostb.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *enp0s8* connected with *switch* device

After the creation of the VM, Vagrant will run *host-1b.sh* provisioning script.
##### *Host 1B* provisioning script
This line switches on the interface needed:
```bash
ip link set dev enp0s8 up
```

This line assigns the appropriate IP address to the interface:
```bash
ip addr add 192.168.4.1/23 dev enp0s8
```

These line is used to create a static route between *host-b* and *router-1*, *router-2*, *host-c* usign the interface enp0s8 with gateway 192.168.5.254:
```bash
ip route add 192.168.6.0/23 via 192.168.5.254 dev enp0s8
```

This line is used to make communication between subnet A and B available. If someone wish to do so, the line before should be commented and this one uncommented:
```bash
# ip route add 192.168.0.0/16 via 192.168.5.254 dev enp0s8
```

#### Host 2C
VM for *host-2c* is created with the following code in the Vagrantfile:
```ruby
  config.vm.define "host-c" do |hostc|
    hostc.vm.box = "ubuntu/bionic64"
    hostc.vm.hostname = "host-c"
    hostc.vm.network "private_network", virtualbox__intnet: "broadcast_router-south-2", auto_config: false
    hostc.vm.provision "shell", path: "host-2c.sh"
    hostc.vm.provider "virtualbox" do |vb|
      vb.memory = 512
    end
  end
```

Interfaces created:
* *enp0s8* connected with *router-2* device

After the creation of the VM, Vagrant will run *host-2c.sh* provisioning script.
##### *Host 2C* provisioning script
These lines are used to setup a repository and install docker engine:
```bash
sudo su
apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce
```

This line switches on the interface needed:
```bash
ip link set dev enp0s8 up
```

This line assigns the appropriate IP address to the interface:
```bash
ip addr add 192.168.6.1/24 dev enp0s8
```

These line is used to create a static route between *host-c* and *router-1*, *router-2*, *host-a*, *host-b* usign the interface enp0s8 with gateway 192.168.6.254:
```bash
ip route add 192.168.0.0/16 via 192.168.6.254 dev enp0s8
```

This line is used to pull the requested image from DockerHub:
```bash
sudo docker pull dustnic82/nginx-test:latest
```

This line is used to run the image pulled:
```bash
sudo docker run --name Test-docker -p 80:80 -d dustnic82/nginx-test:latest
```
##### Testing docker
To verify that the docker image is running the following command can be used from host-c:
```bash
sudo docker pc
```

This is the command to reach the docker from host-a and host-b:
```bash
curl 192.168.6.1
```
#### Switch
VM for *switch* is created with the following code in the Vagrantfile:
```ruby
  config.vm.define "switch" do |switch|
    switch.vm.box = "ubuntu/bionic64"
    switch.vm.hostname = "switch"
    switch.vm.network "private_network", virtualbox__intnet: "broadcast_router-south-1", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "broadcast_host_a", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "broadcast_host_b", auto_config: false
    switch.vm.provision "shell", path: "switch.sh"
    switch.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *enp0s8* connected with *router-1* device
* *enp0s9* connected with *host-1a* device
* *enp0s10* connected with *host-1b* device

After the creation of the VM, Vagrant will run *switch.sh* provisioning script.
##### *Switch* provisioning script
These lines updates apt dependancies and install the needed tools to configure the switch:
```bash
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common
```

These lines configure a switch with the appropriate ports for the VLANs:
```bash
ovs-vsctl add-br switch
ovs-vsctl add-port switch enp0s8 
ovs-vsctl add-port switch enp0s9 tag=100
ovs-vsctl add-port switch enp0s10 tag=200
```

These lines finally switch on the interfaces and the ovs system:
```bash
ip link set enp0s8 up
ip link set enp0s9 up
ip link set enp0s10 up
ip link set dev ovs-system up
```
