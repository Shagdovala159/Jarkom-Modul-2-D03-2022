# Jarkom-Modul-2-D03-2022

### Kelompok D03

| **No** | **Nama**                   | **NRP**    |
| ------ | -------------------------- | ---------- |
| 1      | Antonio Taifan Montana     | 5025201219 |
| 2      | Wina Tungmiharja           | 5025201242 |
| 3      | Vania Rizky Juliana Wachid | 5025201215 |

PREFIX IP Kelompok = ```192.186```
## 1
> WISE akan dijadikan sebagai DNS Master, Berlint akan dijadikan DNS Slave, dan Eden akan digunakan sebagai Web Server. Terdapat 2 Client yaitu SSS, dan Garden. Semua node terhubung pada router Ostania, sehingga dapat mengakses internet

Buat semua node terhubung dengan internet
Pada Ostania ketikkan
```iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.186.0.0/16```
lalu ketikkan command 
```echo nameserver 192.168.122.1 > /etc/resolv.conf```
ke semua node agar terhubung pada internet
coba ping google, berhasil semua maka semua node sudah terhubung dengan internet

## 2
> Untuk mempermudah mendapatkan informasi mengenai misi dari Handler, bantulah Loid membuat website utama dengan akses wise.yyy.com dengan alias www.wise.yyy.com pada folder wise

nano /etc/bind/named.conf.local
zone "wise.d03.com" {
    type master;
    file "/etc/bind/wise/wise.d03.com";
};
mkdir /etc/bind/wise
cp /etc/bind/db.local /etc/bind/wise/wise.d03.com
nano /etc/bind/wise/wise.d03.com
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     wise.d03.com. root.wise.d03.com. (
                     2022102501         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      wise.d03.com.
@       IN      A       192.186.3.2
@       IN      AAAA    wise.d03.com

3.
wise nano /etc/bind/wise/wise.d03.com
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     wise.d03.com. root.wise.d03.com. (
                     2022102501         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      wise.d03.com.
@       IN      A       192.186.3.2
www     IN      CNAME   wise.d03.com.
eden   IN      A       192.186.2.3
www.eden IN    CNAME   eden.wise.d03.com.

4.
pada WISE tambahkan nano /etc/bind/named.conf.local
zone "3.186.192.in-addr.arpa" {
    type master;
    file "/etc/bind/wise/3.186.192.in-addr.arpa";
};

cp /etc/bind/db.local /etc/bind/wise/3.186.192.in-addr.arpa
nano /etc/bind/wise/3.186.192.in-addr.arpa

;
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	wise.d03.com. root.wise.d03.com. (
			2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
3.186.192.in-addr.arpa. IN	NS	wise.d03.com.
2			IN	PTR	wise.d03.com.

service bind9 restart

Untuk mengecek apakah konfigurasi sudah benar atau belum, lakukan perintah berikut pada client SSS

// Install package dnsutils
// Pastikan nameserver di /etc/resolv.conf telah dikembalikan sama dengan nameserver dari Ostania
apt-get update
apt-get install dnsutils

//Kembalikan nameserver agar tersambung dengan EniesLobby
nano /etc/resolv.conf 192.186.3.2
host -t PTR 192.186.3.2

5.
nano /etc/bind/named.conf.local
zone "wise.d03.com" {
    type master;
    notify yes;
    also-notify { 192.186.2.2; }; // Masukan IP Berlint tanpa tanda petik
    allow-transfer { 192.186.2.2; }; // Masukan IP Berlint tanpa tanda petik
    file "/etc/bind/wise/wise.d03.com";
};

6.
nano /etc/bind/wise/wise.d03.com
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA	wise.d03.com. root.wise.d03.com. (
                     2021100401         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      wise.d03.com.
@       IN      A       192.186.3.2
www     IN      CNAME   wise.d03.com.
eden   IN      A       192.186.2.3
www.eden IN    CNAME   eden.wise.d03.com.
operation   IN      NS      ns1

Kemudian, melakukan pengeditan pada named.conf.options dnnsec, dan menambahkan allow-query{any;};

nano /etc/bind/named.conf.options
tambahkan // ke dnssec-validation auto;
allow-query{any;};

pada Berlint
nano /etc/bind/named.conf.local
// SLAVE
zone "wise.d03.com" {
    type slave;
    masters { 192.186.3.2; }; // Masukan IP WISE tanpa tanda petik
    file "/var/lib/bind/wise.d03.com";
};

// DELEGASI
zone "operation.wise.d03.com" {
    type master;
    file "/etc/bind/operation/operation.wise.d03.com"
};

mkdir /etc/bind/operation
cp /etc/bind/db.local /etc/bind/operation/operation.wise.d03.com
nano /etc/bind/operation/operation.wise.d03.com
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     operation.wise.d03.com. root.operation.wise.d03.com. (
                              2021100401                ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      operation.wise.d03.com.
@       IN      A       192.186.2.2
www     IN      CNAME   operation.wise.d03.com.

service bind9 restart

ping operation.wise.d03.com.

7. 
nano /etc/bind/operation/operation.wise.d03.com
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA    operation.wise.d03.com. root.operation.wise.d03.com. (
                              2021100401                ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS     operation.wise.d03.com.
@       IN      A       192.186.2.2
www     IN      CNAME  operation.wise.d03.com.
strix IN      A       192.186.2.3
www.strix IN  CNAME   strix.operation.wise.d03.com.

ping strix.operation.wise.yyy.com dan www.strix.operation.wise.yyy.com

8.
