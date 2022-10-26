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


## 5.
> Agar dapat tetap dihubungi jika server WISE bermasalah, buatlah juga Berlint sebagai DNS Slave untuk domain utama

### Konfigurasi server WISE
Edit file /etc/bind/named.conf.local dan sesuaikan dengan syntax berikut  
<img width="527" alt="Screen Shot 2022-10-26 at 3 59 55 PM" src="https://user-images.githubusercontent.com/57696730/197982884-fa9981b6-74e6-41d1-9969-72630322b174.png">
Lakukan restart bind9  
```shell
service bind9 restart
```
### Konfigurasi server Berlint
install bind  
```shell
apt-get update
apt-get install bind9 -y
```
Edit file /etc/bind/named.conf.local dan sesuaikan dengan syntax berikut
<img width="473" alt="Screen Shot 2022-10-26 at 4 01 26 PM" src="https://user-images.githubusercontent.com/57696730/197983227-2695bf6a-5180-4fcf-b194-39ab07e67b00.png">
Lakukan restart bind9  
```shell
service bind9 restart
```
### Testing
Pada server WISE silahkan matikan service bind9
```shell
service bind9 stop
```
Pada client SSS pastikan pengaturan nameserver mengarah ke IP WISE dan IP Berlint  
<img width="254" alt="Screen Shot 2022-10-26 at 4 02 56 PM" src="https://user-images.githubusercontent.com/57696730/197983574-f9239e31-57fb-45c8-9d5a-f73a74556081.png">
Lakukan ping ke wise.d03.com pada client SSS. Jika ping berhasil maka konfigurasi DNS slave telah berhasil  
<img width="588" alt="Screen Shot 2022-10-26 at 4 03 36 PM" src="https://user-images.githubusercontent.com/57696730/197983739-55a381ee-6fb9-4638-8083-ea0d3f6d9428.png">
Slave telah berhasil dibuat.  

## 6.
> Karena banyak informasi dari Handler, buatlah subdomain yang khusus untuk operation yaitu operation.wise.yyy.com dengan alias www.operation.wise.yyy.com yang didelegasikan dari WISE ke Berlint dengan IP menuju ke Eden dalam folder operation 

### Konfigurasi pada server WISE
Pada WISE tambahkan line baru pada file wise.d03.com
```shell
nano /etc/bind/wise/wise.d03.com
```
Edit seperti :  
<img width="609" alt="Screen Shot 2022-10-26 at 4 09 31 PM" src="https://user-images.githubusercontent.com/57696730/197985168-737063bc-066d-4941-8984-aaf2f4b5a274.png">
Kemudian edit file /etc/bind/named.conf.options pada WISE seperti ini :
<img width="460" alt="Screen Shot 2022-10-26 at 4 18 23 PM" src="https://user-images.githubusercontent.com/57696730/197987744-4c45e1d3-9264-4bfe-950b-133ad9fd01d3.png">
Kemudian edit file /etc/bind/named.conf.local menjadi seperti gambar di bawah:  
<img width="645" alt="Screen Shot 2022-10-26 at 4 20 45 PM" src="https://user-images.githubusercontent.com/57696730/197988336-93bdb6dc-2a09-4f10-8d81-9d47603063bd.png">
restart bind9  
```shell
service bind9 restart
```

### Konfigurasi pada server Berlint
Pada Berlint edit file /etc/bind/named.conf.options
```shell
nano /etc/bind/named.conf.options
```
Kemudian comment ```dnssec-validation auto;``` dan tambahkan baris berikut pada /etc/bind/named.conf.options  
```shell
allow-query{any;};
```
seperti pada gambar ini:
<img width="471" alt="Screen Shot 2022-10-26 at 4 23 57 PM" src="https://user-images.githubusercontent.com/57696730/197989056-5c768eee-514b-4692-9bf2-336f65f34885.png">
Lalu edit file /etc/bind/named.conf.local menjadi seperti gambar di bawah:  
<img width="626" alt="Screen Shot 2022-10-26 at 4 25 45 PM" src="https://user-images.githubusercontent.com/57696730/197989464-d313762e-f474-4884-ab9f-3fb218185158.png">
Buat folder operation
```shell
mkdir /etc/bind/operation
```
Copy db.local ke operation.wise.d03.com
```shell
cp /etc/bind/db.local /etc/bind/operation/operation.wise.d03.com
```
Edit isinya seperti dibawah ini, jangan lupa tambahkan CNAME untuk aliasnya
```shell
nano /etc/bind/operation/operation.wise.d03.com
```
<img width="819" alt="Screen Shot 2022-10-26 at 4 31 31 PM" src="https://user-images.githubusercontent.com/57696730/197990815-3a397704-0831-46f9-8b74-ff0326484ec8.png">
Restart
```shell
service bind9 restart
```
### Testing

ping operation.wise.d03.com pada client SSS
<img width="662" alt="Screen Shot 2022-10-26 at 4 45 42 PM" src="https://user-images.githubusercontent.com/57696730/197994063-e4b27e7e-eb06-4226-844b-6366f129bb42.png">
ping berhasil

## 7
>Untuk informasi yang lebih spesifik mengenai Operation Strix, buatlah subdomain melalui Berlint dengan akses strix.operation.wise.yyy.com dengan alias www.strix.operation.wise.yyy.com yang mengarah ke Eden  

Pada Berlint buat domain untuk strix.operation.wise.d03.com dengan alias www.strix.operation.wise.d03.com  
instalasi bind terlebih dahulu  
``shell
apt-get update
apt-get install bind9 -y
```
karena sudah ada foldernya jadi tinggal edit saja.    
Edit folder ```operation.wise.d03.com```
``` shell
nano /etc/bind/operation/operation.wise.d03.com
```
edit seperti dibawah ini, jangan lupa tambahkan CNAME untuk aliasnya :

<img width="844" alt="Screen Shot 2022-10-26 at 5 18 23 PM" src="https://user-images.githubusercontent.com/57696730/198001543-f867584b-fdbb-4425-8c6f-752a1beb1f82.png">
Restart
```shell
service bind9 restart
```
### Testing
Lakukan ping ke domain strix.operation.wise.d03.com dan www.strix.operation.wise.d03.com dari client SSS
<img width="708" alt="Screen Shot 2022-10-26 at 5 21 16 PM" src="https://user-images.githubusercontent.com/57696730/198002088-a04a61ce-6be3-4fc2-91a0-dc67d095f929.png">


8.
