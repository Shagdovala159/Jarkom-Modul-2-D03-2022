#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

apt-get update
apt-get install dnsutils

cp source/named.conf.local /etc/bind/named.conf.local
cp source/operation.wise.d03.com /etc/bind/operation/operation.wise.d03.com 
cp source/named.conf.options /etc/bind/named.conf.options
service bind9 restart

