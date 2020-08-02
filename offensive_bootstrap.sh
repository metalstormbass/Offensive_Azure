#!/bin/bash

#### Update and download docker
until sudo apt-get update && apt-get -y install docker.io;do
    sleep 1
done


####Install Nmap
until sudo apt-get -y install nmap;do
    sleep 1
done

####Install Metasploit & Dependencies
until sudo curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  sudo chmod 755 msfinstall && \
  sudo ./msfinstall;do
    sleep 1
done

####Install Go

until sudo apt-get install -y golang;do
    sleep 1
done


####Install Gobuster
until sudo go get github.com/OJ/gobuster;do
    sleep 1
done

sudo mv go/bin/gobuster /usr/bin/gobuster  

####Install Python3.8
until sudo apt-get install -y python3.8;do
    sleep 1
done
until sudo apt install -y python3-pip; do
    sleep 1
done

until sudo pip3 install pipenv;do
    sleep 1
done



####Install Powershell

sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
until sudo apt-get update -y && sudo apt-get install -y libicu55;do
    sleep 1
done

# Download the Microsoft repository GPG keys
until wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb;do
    sleep 1
done

# Register the Microsoft repository GPG keys
until sudo  dpkg -i packages-microsoft-prod.deb;do
    sleep 1
done

# Update the list of productspip
until sudo apt-get update -y;do
    sleep 1
done

# Install PowerShell
until sudo apt-get install -y powershell;do
    sleep 1
done

#### Install AZ
until sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg;do
    sleep 1
done

curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
    
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
    
until sudo apt-get install azure-cli -y;do
    sleep 1
done

####Install Microburst

until sudo git clone https://github.com/NetSPI/MicroBurst.git /home/$name/MicroBurst;do
    sleep 1
done

####Install Stormspotter
until sudo docker run --name stormspotter -p7474:7474 -p7687:7687 -d --env NEO4J_AUTH=neo4j/$password neo4j:3.5.18;do
    sleep 1
done

git clone https://github.com/Azure/Stormspotter /home/$name/Stormspotter

cd /home/$name/Stormspotter/

until pipenv install .;do
    sleep 1
done

#Modify Networking for Accessing Stormspotter Remotely
sudo sysctl -w net.ipv4.conf.eth0.route_localnet=1
sudo iptables -t nat -I PREROUTING -p tcp -d 0.0.0.0/0 --dport 8050 -j DNAT --to-destination 127.0.0.1:8050
