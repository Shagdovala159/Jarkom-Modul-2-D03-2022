D03	Antonio Taifan Montana
	Wina Tungmiharja
	Vania Rizky Juliana Wachid

192.186

Foosha

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.186.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.186.2.1
	netmask 255.255.255.0

Loguetown

auto eth0
iface eth0 inet static
	address 192.186.1.2
	netmask 255.255.255.0
	gateway 192.186.1.1

Alabasta

auto eth0
iface eth0 inet static
	address 192.186.1.3
	netmask 255.255.255.0
	gateway 192.186.1.1
EniesLobby
auto eth0
iface eth0 inet static
	address 192.186.2.2
	netmask 255.255.255.0
	gateway 192.186.2.1
Water7
auto eth0
iface eth0 inet static
	address 192.186.2.3
	netmask 255.255.255.0
	gateway 192.186.2.1

terminal Foosha
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.186.0.0/16
 cat /etc/resolv.conf
 192.168.122.1

 ke semua terminal
 echo nameserver 192.168.122.1 > /etc/resolv.conf
 
 apt-get update
apt-get install bind9 -y'
nano /etc/bind/named.conf.local
lanjut bawah
zone "jarkom2022.com" {
	type master;
	file "/etc/bind/jarkom/jarkom2022.com";
};
akhir
mkdir /etc/bind/jarkom
cp /etc/bind/db.local /etc/bind/jarkom/jarkom2022.com
nano /etc/bind/jarkom/jarkom2022.com
service bind9 restart
