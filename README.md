# DNCS-LAB
Design of Networks and Communication Systems, A.Y. 2019/20,University of Trento

Students:
- Matteo Strada, MAT: 214980
- Giovanni Costa, MAT: 

## Topology
This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |eth1
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
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

| Subnet name |  Subnet address  |        Netmask       |      Devices      |
|:-----------:|:----------------:|:--------------------:|:-----------------:|
|      A      |  192.168.0.0/23  |  255.255.254.0 = 23  | *host-1-a*, *router-1* |
|      B      | 192.168.4.0/23   |  255.255.254.0 = 23  | *host-1-b*, *router-1* |
|      C      |  172.16.0.0/24   | 255.255.255.252 = 24 | *host-2-c*, *router-2* |
|      D      | 192.168.255.252/30 | 255.255.255.252 = 30 | *router-1*, *router-2* |


* Subnet **A** includes *host-1-a* and *router-1*. It has a */23* subnet mask to allow up to 2<sup>32-23</sup>-2= 510 hosts (assignment request was 281 hosts)
* Subnet **B** includes *host-1-b* and *router-1*. It has a */23* subnet mask to allow up to 2<sup>32-23</sup>-2= 510 hosts (assignment request was 420 hosts)
* Subnet **C** includes *router-2* and *host-2-c*. It has a */30* subnet mask to allow up to 2<sup>32-24</sup>-2= 254 hosts (assignment request was 163 hosts)
* Subnet **D** includes *router-1* and *router-2*. It has a */30* subnet mask to allow up to 2<sup>32-30</sup>-2= 2 hosts (subnet completely used)

### VLANs

Due to network topology structure, there is a need for the configuration of 2 VLANs to allow *router-1* communicate with subnet **A** and **B** via its unique connection.

The VIDs have been set as following:

| VID | Subnet |
|:---:|:------:|
|  10 |    A   |
|  20 |    B   |

### IP interface setup

The IP assegnation summary for every interface:

|  Device  |  Interface  |     IP address     | Subnet |
|:--------:|:-----------:|:------------------:|:------:|
| host-1-a |    enp0s8   |   192.168.0.1/23   |    A   |
| router-1 |  enp0s8.10  |  192.168.1.254/23  |    A   |
| host-1-b |    enp0s8   |   192.168.4.1/23   |    B   |
| router-1 |  enp0s8.20  |  192.168.5.254/23  |    B   |
| router-2 |    enp0s8   |   172.16.0.254/24  |    C   |
| host-2-c |    enp0s8   |   172.16.0.1/24    |    C   |
| router-1 |    enp0s9   | 192.168.255.253/30 |    D   |
| router-2 |    enp0s9   | 192.168.255.254/30 |    D   |

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
    router1.vm.network "private_network", virtualbox__intnet: "router1-switch", auto_config: false
    router1.vm.network "private_network", virtualbox__intnet: "router1-router2", auto_config: false
    router1.vm.provision "shell", path: "router-1.sh"
    router1.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *eth1* connected with *switch* device
* *eth2* connect with *router-2* device

After the creation of the VM, Vagrant will run *common.sh* provisioning script.
##### *Router 1* provisioning script
+script explanation

#### Router 2
VM for *router-2* is created with the following code in the Vagrantfile:
```ruby
  config.vm.define "router-2" do |router2|
    router2.vm.box = "ubuntu/bionic64"
    router2.vm.hostname = "router-2"
    router2.vm.network "private_network", virtualbox__intnet: "router2-hostc", auto_config: false
    router2.vm.network "private_network", virtualbox__intnet: "router2-router1", auto_config: false
    router2.vm.provision "shell", path: "router-2.sh"
    router2.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *eth1* connected with *host-2c* device
* *eth2* connect with *router-1* device

After the creation of the VM, Vagrant will run *common.sh* provisioning script.
##### *Router 2* provisioning script
+script explanation

#### Host 1A
VM for *host-1a* is created with the following code in the Vagrantfile:
```ruby
  config.vm.define "host-a" do |hosta|
    hosta.vm.box = "ubuntu/bionic64"
    hosta.vm.hostname = "host-a"
    hosta.vm.network "private_network", virtualbox__intnet: "hosta-switch", auto_config: false
    hosta.vm.provision "shell", path: "host-1a.sh"
    hosta.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *eth1* connected with *switch* device

After the creation of the VM, Vagrant will run *common.sh* provisioning script.
##### *Host 1A* provisioning script
+script explanation

#### Host 1B
VM for *host-1b* is created with the following code in the Vagrantfile:
```ruby
  config.vm.define "host-b" do |hostb|
    hostb.vm.box = "ubuntu/bionic64"
    hostb.vm.hostname = "host-b"
    hostb.vm.network "private_network", virtualbox__intnet: "hostb-switch", auto_config: false
    hostb.vm.provision "shell", path: "host-1b.sh"
    hostb.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *eth1* connected with *switch* device

After the creation of the VM, Vagrant will run *common.sh* provisioning script.
##### *Host 1B* provisioning script
+script explanation

#### Host 2C
VM for *host-2c* is created with the following code in the Vagrantfile:
```ruby
  config.vm.define "host-c" do |hostc|
    hostc.vm.box = "ubuntu/bionic64"
    hostc.vm.hostname = "host-c"
    hostc.vm.network "private_network", virtualbox__intnet: "hostc-router2", auto_config: false
    hostc.vm.provision "shell", path: "host-2c.sh"
    hostc.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *eth1* connected with *router-2* device

After the creation of the VM, Vagrant will run *common.sh* provisioning script.
##### *Host 2C* provisioning script
+script explanation

#### Switch
VM for *switch* is created with the following code in the Vagrantfile:
```ruby
 config.vm.define "switch" do |switch|
    switch.vm.box = "ubuntu/bionic64"
    switch.vm.hostname = "switch"
    switch.vm.network "private_network", virtualbox__intnet: "switch-router1", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "switch-hosta", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "switch-hostb", auto_config: false
    switch.vm.provision "shell", path: "switch.sh"
    switch.vm.provider "virtualbox" do |vb|
      vb.memory = 256
    end
  end
```

Interfaces created:
* *eth1* connected with *router-1* device
* *eth2* connected with *host-1a* device
* *eth3* connected with *host-1b* device

After the creation of the VM, Vagrant will run *switch.sh* provisioning script.
##### *Switch* provisioning script
+script explanation