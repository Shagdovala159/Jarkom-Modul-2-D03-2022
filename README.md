# Jarkom-Modul-2-D03-2022

### Kelompok D03

| **No** | **Nama**                   | **NRP**    |
| ------ | -------------------------- | ---------- |
| 1      | Antonio Taifan Montana     | 5025201219 |
| 2      | Wina Tungmiharja           | 5025201242 |
| 3      | Vania Rizky Juliana Wachid | 5025201215 |

```PREFIX IP Kelompok = 192.186```  
 
## 1

> WISE akan dijadikan sebagai DNS Master, Berlint akan dijadikan DNS Slave, dan Eden akan digunakan sebagai Web Server. 
Terdapat 2 Client yaitu SSS, dan Garden. Semua node terhubung pada router Ostania, sehingga dapat mengakses internet

**Ostania**

- Command agar semua node dapat terhubung internet
```shell
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.186.0.0/16
```
Cek IP DNS dengan mengetikkan command  
```shell
cat /etc/resolv.conf
```  
Lalu ketikkan command   
```shell
echo nameserver 192.168.122.1 > /etc/resolv.conf
```  
ke semua node agar terhubung pada internet 
Cek menggunakan ping google  
Hasil ping ke `google.com`
![collage](https://user-images.githubusercontent.com/64743796/197951880-46fc88dd-acc6-42ed-9aee-7abeb9c79e9a.jpg)


## 2

> Untuk mempermudah mendapatkan informasi mengenai misi dari Handler, bantulah Loid membuat website utama dengan 
akses `wise.yyy.com` dengan alias `www.wise.yyy.com` pada folder wise `yyy pada url = D03`

- buat domain untuk `wise.yyy.com` lalu menggunakan CNAME untuk `www.wise.yyy.com.`
-Instalasi bind terlebih dahulu  
``` shell
apt-get update
apt-get install bind9 -y
```
- menggunakan `nano` untuk mengedit ```named.conf.local```
```shell
nano /etc/bind/named.conf.local
```
Lalu isikan dengan:  
```shell
zone "wise.d03.com" {
    type master;
    file "/etc/bind/wise/wise.d03.com";
};
```

- copy dvlocal menggunakan cp ke root folder wise `wise.d03.com` 

```shell
mkdir /etc/bind/wise
cp /etc/bind/db.local /etc/bind/wise/wise.d03.com
nano /etc/bind/wise/wise.d03.com
```
-edit isinya seperti berikut, ganti menggunakan IP dari ```WISE```, jangan lupa tambahkan CNAME untuk aliasnya
```shell
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
```
- lakukan `service bind9 restart` pada kedua node

Hasil ping ke `wise.d03.com`

![Screenshot 2022-10-25 032449](https://user-images.githubusercontent.com/64743796/197955389-7ddbeba4-0237-4826-bdd4-4c6615d8e28d.png)


## 3

> Setelah itu ia juga ingin membuat subdomain `eden.wise.yyy.com` dengan alias 
`www.eden.wise.yyy.com` yang diatur DNS-nya di WISE dan mengarah ke Eden

- buka `/etc/bind/wise/wise.d03.com`

```shell
nano /etc/bind/wise/wise.d03.com
```
- tambahkan line baru
```shell
eden   IN      A       192.186.2.3
www.eden IN    CNAME   eden.wise.d03.com.
```

- menjadi seperti ini
```shell
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
```

![Screenshot 2022-10-25 032941](https://user-images.githubusercontent.com/64743796/197957121-59fb1d3c-1354-4460-ab59-eb61d2b59869.png)

- lakukan `service bind9 restart` pada node

Hasil ping ke `eden.wise.d03.com`

![Screenshot 2022-10-25 033111](https://user-images.githubusercontent.com/64743796/197957248-cb4ba53d-40e0-490c-a227-cd44d3e9b937.png)


4.
Edit file /etc/bind/named.conf.local pada WISE
```shell
nano /etc/bind/named.conf.local
```
Tambahkan reverse dari 3 byte awal dari IP yang ingin dilakukan Reverse DNS  
```shell
zone "3.186.192.in-addr.arpa" {
    type master;
    file "/etc/bind/wise/3.186.192.in-addr.arpa";
};
```

<img width="620" alt="Screen Shot 2022-10-26 at 3 08 35 PM" src="https://user-images.githubusercontent.com/57696730/197970584-16683041-db40-4eba-8ba9-ced569c3dc35.png">

Copykan file db.local pada path /etc/bind ke dalam folder jarkom yang baru saja dibuat dan ubah namanya menjadi ```3.186.192.in-addr.arpa```  
```shell
cp /etc/bind/db.local /etc/bind/wise/3.186.192.in-addr.arpa
```  
Edit file 3.186.192.in-addr.arpa 
```shell
nano /etc/bind/wise/3.186.192.in-addr.arpa
```
Lalu ganti seperti pada :  

<img width="605" alt="Screen Shot 2022-10-26 at 3 26 41 PM" src="https://user-images.githubusercontent.com/57696730/197974667-384e13d7-97d5-4d28-8cfc-b5122ebb93ce.png">

Lalu restart  
```shell
service bind9 restart
```
Untuk mengecek apakah konfigurasi sudah benar atau belum, lakukan perintah berikut pada client SSS  
```shell
apt-get update
apt-get install dnsutils
```
Kembalikan nameserver di /etc/resolv.conf agar tersambung dengan WISE  
```shell
nano /etc/resolv.conf
```
Ganti dengan  
```shell
nameserver	192.186.3.2
```
Lalu cek  
```shell
host -t PTR 192.186.3.2
```
Maka akan muncul ini jika berhasil
<img width="502" alt="Screen Shot 2022-10-26 at 3 28 56 PM" src="https://user-images.githubusercontent.com/57696730/197975151-2565ab7b-b7cd-4aee-9970-bbfcf2597c60.png">


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
