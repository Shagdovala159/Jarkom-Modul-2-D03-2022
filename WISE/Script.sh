#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

mkdir /etc/bind/wise
cp source/named.conf.local /etc/bind/named.conf.local
cp source/wise.d03.com /etc/bind/wise/wise.d03.com
cp source/3.186.192.in-addr.arpa /etc/bind/wise/3.186.192.in-addr.arpa
cp source/named.conf.options /etc/bind/named.conf.options
service bind9 restart

