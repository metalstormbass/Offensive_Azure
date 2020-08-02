#!/bin/bash

####Install Linux Desktop
until sudo apt-get update -y && sudo apt-get sudo apt-get -y install xfce4;do
    sleep 1
done

until sudo apt-get -y install xrdp;do
    sleep 1
done

sudo systemctl enable xrdp

echo xfce4-session >~/.xsession

sudo service xrdp restart

#### Update and download docker
until sudo  apt-get -y install docker.io;do
    sleep 1
done


####Install Powershell

# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb

# Register the Microsoft repository GPG keys
until sudo  dpkg -i packages-microsoft-prod.deb;do
    sleep 1
done

# Update the list of products
until sudo apt-get update;do
    sleep 1
done

# Install PowerShell
until sudo apt-get install -y powershell;do
    sleep 1
done

####Install Nmap
until sudo sudo apt-get -y install nmap

####Install Metasploit & Dependencies
until sudo curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  sudo chmod 755 msfinstall && \
  sudo ./msfinstall;do
    sleep 1
done

###Install Go
curl -O https://storage.googleapis.com/golang/go1.12.9.linux-amd64.tar.gz

sudo tar -xvf go1.12.9.linux-amd64.tar.gz

sudo chown -R root:root ./go
sudo mv go /usr/local

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

sudo go get github.com/OJ/gobuster

  
  