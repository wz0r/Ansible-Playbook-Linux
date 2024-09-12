#!/bin/bash

ip=10.80.6.123
gw=10.80.6.1
interface=ens32

cd /etc/default/
cp grub grub.$(date +%y%m%d)
sed -i 's/=""/="netcfg\/do_not_use_netplan=true"/g' grub
sudo update-grub
sudo apt update
sudo apt install mc ccze ifupdown net-tools resolvconf curl -y

cat << EOF > /etc/network/interfaces.d/$interface
auto $interface
iface $interface inet static
address $ip
netmask 255.255.255.0
gateway $gw
dns-nameservers 10.80.3.2,10.99.3.2 8.8.8.8 8.8.4.4
#up route add -net 172.17.100.0/24 gw 10.80.15.1
EOF

sudo unlink /etc/resolv.conf

cat << EOF >> /etc/resolv.conf
nameserver 10.80.3.2
nameserver 10.99.3.2
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

sudo systemctl stop systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online systemd-resolved
sudo systemctl disable systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online systemd-resolved
sudo systemctl mask systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online systemd-resolved

sudo apt-get --assume-yes purge nplan netplan.io
#sudo shutdown -r now
