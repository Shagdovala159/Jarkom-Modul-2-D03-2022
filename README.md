# Jarkom-Modul-2-D03-2022

### Kelompok D03

| **No** | **Nama**                   | **NRP**    |
| ------ | -------------------------- | ---------- |
| 1      | Antonio Taifan Montana     | 5025201219 |
| 2      | Wina Tungmiharja           | 5025201242 |
| 3      | Vania Rizky Juliana Wachid | 5025201215 |

```PREFIX IP Kelompok = 192.186```  

### Direktori Jawaban

<details>
  <summary>Expand</summary>
  
 1. [Nomor 1](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#1)
 2. [Nomor 2](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#2)
 3. [Nomor 3](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#3)
 4. [Nomor 4](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#4)
 5. [Nomor 5](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#5)
 6. [Nomor 6](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#6)
 7. [Nomor 7](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#7)
 8. [Nomor 8](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#8)
 9. [Nomor 9](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#9)
 10. [Nomor 10](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#10)
 11. [Nomor 11](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#11)
 12. [Nomor 12](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#12)
 13. [Nomor 13](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#13)
 14. [Nomor 14](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#14)
 15. [Nomor 15](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#15)
 16. [Nomor 16](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#16)
 17. [Nomor 17](https://github.com/Shagdovala159/Jarkom-Modul-2-D03-2022/#17)
</details>
 
 
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


## 4

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

*Konfigurasi server WISE*
Edit file /etc/bind/named.conf.local dan sesuaikan dengan syntax berikut  

<img width="527" alt="Screen Shot 2022-10-26 at 3 59 55 PM" src="https://user-images.githubusercontent.com/57696730/197982884-fa9981b6-74e6-41d1-9969-72630322b174.png">

Lakukan restart bind9  
```shell
service bind9 restart
```
*Konfigurasi server Berlint*
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
*Testing*
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

*Konfigurasi pada server WISE*
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

*Konfigurasi pada server Berlint*

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
*Testing*

ping operation.wise.d03.com pada client SSS

<img width="662" alt="Screen Shot 2022-10-26 at 4 45 42 PM" src="https://user-images.githubusercontent.com/57696730/197994063-e4b27e7e-eb06-4226-844b-6366f129bb42.png">  

ping berhasil

## 7
> Untuk informasi yang lebih spesifik mengenai Operation Strix, buatlah subdomain melalui Berlint dengan akses strix.operation.wise.yyy.com dengan alias www.strix.operation.wise.yyy.com yang mengarah ke Eden  

Pada Berlint buat domain untuk strix.operation.wise.d03.com dengan alias www.strix.operation.wise.d03.com  
instalasi bind terlebih dahulu  
```shell
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
*Testing*

Lakukan ping ke domain strix.operation.wise.d03.com dan www.strix.operation.wise.d03.com dari client SSS

<img width="708" alt="Screen Shot 2022-10-26 at 5 21 16 PM" src="https://user-images.githubusercontent.com/57696730/198002088-a04a61ce-6be3-4fc2-91a0-dc67d095f929.png">


## 8

> Setelah melakukan konfigurasi server, maka dilakukan konfigurasi Webserver. Pertama dengan webserver www.wise.yyy.com. Pertama, Loid membutuhkan webserver dengan DocumentRoot pada `/var/www/wise.yyy.com`

- Config WISE diarahkan ke Skypie
![Screenshot 2022-10-26 013232](https://user-images.githubusercontent.com/64743796/198028646-10e78659-901f-4105-887d-4ce9f87dfe69.png)

![Screenshot 2022-10-26 013543](https://user-images.githubusercontent.com/64743796/198028620-eafebc77-7b5b-4cba-8dde-d7abd5ad6ebb.png)


## 9

> Setelah itu, Loid juga membutuhkan agar url `www.wise.yyy.com/index.php/home` dapat menjadi menjadi `www.wise.yyy.com/home`

- Pertama kita harus membuat alias dari dari `/home` menjadi `/index.php/home`

```shell
<VirtualHost *:80>
        ...
        ServerName wise.d03.com
        ServerAlias www.wise.d03.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.d03.com

        Alias "/home" "/var/www/wise.d03.com/index.php/home"

        ...

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        ...
</VirtualHost>

```

- `lynx http://wise.d03.com/home`

![Screenshot 2022-10-26 033543](https://user-images.githubusercontent.com/64743796/198031302-cf42b628-a0cc-406f-8829-d072322d198f.png)

## 10

> Setelah itu, pada subdomain www.eden.wise.yyy.com, Loid membutuhkan penyimpanan aset yang memiliki DocumentRoot pada /var/www/eden.wise.yyy.com

```shell
<VirtualHost *:80>
        ...
        ServerName eden.wise.d03.com
        ServerAlias www.eden.wise.d03.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.d03.com

        ...

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        ...
</VirtualHost>

```

`lynx http://www.eden.wise.d03.com`

![Screenshot 2022-10-26 035549](https://user-images.githubusercontent.com/64743796/198032744-6dd40343-2ea6-4728-a324-0dc466f7ecab.png)

## 11
> Tidak hanya itu, Loid juga ingin menyiapkan error file 404.html pada folder /error untuk mengganti error kode pada apache
Pada node eden edit eden.wise.d03.com.conf menjadi seperti dibawah ini:
```
echo "
<VirtualHost *:80>
        ServerName eden.wise.d03.com
        ServerAlias www.eden.wise.d03.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.d03.com

        <Directory /var/www/eden.wise.d03.com>
                Options +Indexes
                AllowOverride All
        </Directory>

        <Directory /var/www/eden.wise.d03.com/public>
                Options +Indexes
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
" > /etc/apache2/sites-available/eden.wise.d03.com.conf
```  
enable sitenya  
```
a2ensite eden.wise.d03.com
```  
bikin direktori dan copykan isinya
```
mkdir /var/www/eden.wise.d03.com
cp -r /root/modul2source/eden.wise/. /var/www/eden.wise.d03.com
```  
restart  
```
service apache2 restart
```
echo terserah  
```
echo "<?php echo 'wina vania cantik' ?>" > /var/www/eden.wise.d03.com/index.php  
```
Coba lynx
```
lynx http://www.eden.wise.d03.com/public
```
![11](https://user-images.githubusercontent.com/57696730/199226636-46c61cde-93a6-48fe-befe-2274afef9dd2.png)  

## 12
> Loid juga meminta Franky untuk dibuatkan konfigurasi virtual host. Virtual host ini bertujuan untuk dapat mengakses file asset www.eden.wise.yyy.com/public/js menjadi www.eden.wise.yyy.com/js  

Pada node eden edit eden.wise.d03.com.conf menjadi seperti dibawha ini:
```
echo "
<VirtualHost *:80>
        ServerName eden.wise.d03.com
        ServerAlias www.eden.wise.d03.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.d03.com

        <Directory /var/www/eden.wise.d03.com>
                Options +Indexes
                AllowOverride All
        </Directory>

        <Directory /var/www/eden.wise.d03.com/public>
                Options +Indexes
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        ErrorDocument 404 /error/404.html
</VirtualHost>
" > /etc/apache2/sites-available/eden.wise.d03.com.conf  
```
lalu restart  
```service apache2 restart```  
lalu lynx http://www.eden.wise.d03.com/antonjelek
![12](https://user-images.githubusercontent.com/57696730/199226700-ac3f1119-49e1-4ecf-a934-8b1dd555a9b3.png)  


## 13
> Loid juga meminta Franky untuk dibuatkan konfigurasi virtual host. Virtual host ini bertujuan untuk dapat mengakses file asset www.eden.wise.yyy.com/public/js menjadi www.eden.wise.yyy.com/js

Pada node eden edit eden.wise.d03.com.conf menjadi seperti dibawha ini:
```
echo "
<VirtualHost *:80>
        ServerName eden.wise.d03.com
        ServerAlias www.eden.wise.d03.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.d03.com

        <Directory /var/www/eden.wise.d03.com>
                Options +Indexes
                AllowOverride All
        </Directory>

        <Directory /var/www/eden.wise.d03.com/public>
                Options +Indexes
        </Directory>

        Alias "/js" "/var/www/eden.wise.d03.com/public/js"

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        ErrorDocument 404 /error/404.html
</VirtualHost>
" > /etc/apache2/sites-available/eden.wise.d03.com.conf
```
lalu restart  
```service apache2 restart```  
Coba lynx  
```lalu lynx http://www.eden.wise.d03.com/js```
![13](https://user-images.githubusercontent.com/57696730/199226770-56418263-0ae5-4413-9b0f-3f86c8263634.png)



## 14
> Loid meminta agar www.strix.operation.wise.yyy.com hanya bisa diakses dengan port 15000 dan port 15500

Membuat konfigurasi Web Server di default-wise-1-15000.conf dan default-wise-1-15500.conf sebagai berikut.

### default-wise-1-15000.conf  
```
<VirtualHost *:15000>
        ServerName strix.operation.wise.d03.com
        ServerAlias www.strix.operation.wise.d03.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.d03.com

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

### default-wise-1-15500.conf  
```
<VirtualHost *:15500>
        ServerName strix.operation.wise.d03.com
        ServerAlias www.strix.operation.wise.d03.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.d03.com

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
Kemudian copy file dengan command   
```
cp /root/default-wise-1-15000.conf /etc/apache2/sites-available/strix.operation.wise.d03.com-15000.conf
cp /root/default-wise-1-15500.conf /etc/apache2/sites-available/strix.operation.wise.d03.com-15000.conf
```  

Tambahkan port yang akan di listen pada ports-1.conf sebagi berikut.
```
Listen 80
Listen 15000
Listen 15500

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>
```
Kemudian copi file ```cp /root/ports-1.conf /etc/apache2/ports.conf.```

Kemudian aktifkan a2ensite dengan   
```
a2ensite strix.operation.wise.d03.com-15000
a2ensite strix.operation.wise.d03.com-15500
```

Lakukan pembuatan direktori baru dengan  
```mkdir /var/www/strix.operation.wise.d03.com```

Copy file - file lampiran github ke folder yang telah dibuat  
```
cp -r /root/modul2source-jarkom/strix.operation.wise/. /var/www/strix.operation.wise.d03.com.
```

Restart apache 
```
service apache2 restart.
```

Pada node Garden dan SSS, kita dapat melakukan testing dengan menggunakan lynx pada port 15000 atau 15500  
```
lynx http://www.strix.operation.wise.d03.com:15000 atau lynx http://www.strix.operation.wise.d03.com:15500.
```
![14b](https://user-images.githubusercontent.com/57696730/199226292-6b7a2df6-2f20-4566-87b6-7ab08f6a58ee.png)  
![14a](https://user-images.githubusercontent.com/57696730/199226298-4aef1755-4308-481f-bdbc-8cb41675c20d.png)  




## 15
> Dengan autentikasi username Twilight dan password opStrix dan file di /var/www/strix.operation.wise.yyy

Pada node Eden  

Tambahkan code baru berikut pada ```file default-wise-2-15000.conf``` dan ```default-wise-2-15500.conf``` sebagai berikut.  

### default-wise-2-15000.conf
```
<VirtualHost *:15000>
        ServerName strix.operation.wise.d03.com
        ServerAlias www.strix.operation.wise.d03.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.d03.com

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Directory "var/www/strix.operation.wise.d03.com">
                AuthType Basic
                AuthName "Restricted Content"
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
        </Directory>
</VirtualHost>
```

### default-wise-2-15500.conf  
```
<VirtualHost *:15500>
        ServerName strix.operation.wise.d03.com
        ServerAlias www.strix.operation.wise.d03.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.d03.com

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Directory "var/www/strix.operation.wise.d03.com">
                AuthType Basic
                AuthName "Restricted Content"
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
        </Directory>
</VirtualHost>
```

Copy file dengan command 
```
cp /root/default-wise-2-15000.conf /etc/apache2/sites-available/strix.operation.wise.d03.com-15000
cp /root/default-wise-2-15500.conf /etc/apache2/sites-available/strix.operation.wise.d03.com-15500
```

Kemudian buat autentikasi baru dengan command berikut sehingga memunculkan file ```.htpasswd``` pada dengan command 
```
htpasswd -b -c /etc/apache2/.htpasswd Twilight opStrix.
```

Restart apache   
```service apache2 restart.```  

Ketika web server ```strix.operation.wise.d03.com``` diakses, akan diminta authentikasi username dan password.  
![15a](https://user-images.githubusercontent.com/57696730/199225992-cd64e4b8-e0a4-4459-9804-6525db8eff47.png)  
![15b](https://user-images.githubusercontent.com/57696730/199226015-3764ad89-26a2-484a-8e0d-bc1b263cfadd.png)  

Input username Twilight dan password opStrix.
![15c](https://user-images.githubusercontent.com/57696730/199226127-d8342a97-4d30-4876-ad70-2b4cc5a94602.png)

Kemudian akan menampilkan hasil berikut.
![15d](https://user-images.githubusercontent.com/57696730/199226157-f75ac658-0d7b-4f1a-842f-6b9516208168.png)


## 16
> dan setiap kali mengakses IP Eden akan dialihkan secara otomatis ke ```www.wise.yyy.com```

Pada node Eden

Konfigurasi pada file ```default-1.conf``` sebagai berikut.
``` shell
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.d03.com

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```  
Copy file tersebut dengan command   
```cp /root/default-1.conf /etc/apache2/sites-available/000-default.conf```


Konfigurasi pada file ```wise-1.htaccess``` sebagai berikut.  
```shell
a2enmod rewrite
RewriteEngine On
RewriteBase /
RewriteCond %{HTTP_HOST} ^192\.186\.2\.3$
RewriteRule ^(.*)$ http://www.wise.d03.com/$1 [L,R=301]
``` 
Inti dari konfigurasi tersebut adalah kita melakukan cek apakah pengaksesan berupa ip ke arah Eden jika hal tersebut terpenuhi maka kita membuat rule untuk melakukan direct ke ```www.wise.d03.com.```  

Kemudian copy file dengan command 
```
cp /root/wise-1.htaccess /var/www/wise.d03.com/.htaccess.
```

Restart apache 
```
service apache2 restart.
```

Testing pada node Garden dan SSS dengan command ```lynx 192.186.2.3```
![16](https://user-images.githubusercontent.com/57696730/199225900-f72f2d4e-933a-4cd3-a734-cafe699272a0.png)

## 17
> Karena website www.eden.wise.yyy.com semakin banyak pengunjung dan banyak modifikasi sehingga banyak gambar-gambar yang random, maka Loid ingin mengubah request gambar yang memiliki substring “eden” akan diarahkan menuju eden.png. Bantulah Agent Twilight dan Organisasi WISE menjaga perdamaian!

Pada node Eden

Konfigurasi pada ```file wise-2.htaccess``` sebagai berikut.  
```
a2enmod rewrite
ewriteEngine On
RewriteBase /
RewriteCond %{REQUEST_URI} !\beden.png\b
RewriteRule eden http://eden.wise.d03.com/public/images/eden.png$1 [L,R=301]
```  
Inti dari konfigurasi tersebut adalah kita melakukan cek apakah request mengandung substring eden, jika ya maka akan diarahkan ke ```http://eden.wise.d03.com/public/images/eden.png.```

Copy file dengan command
```
cp /root/wise-2.htaccess /var/www/eden.wise.d03.com/.htaccess.
```  

Konfigurasi pada ```file default-wise-7.conf``` sebagai berikut.  
```
<VirtualHost *:80>
        ServerName eden.wise.d03.com
        ServerAlias www.eden.wise.d03.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.d03.com

        <Directory /var/www/eden.wise.d03.com>
                Options +Indexes
                AllowOverride All
        </Directory>

        <Directory /var/www/eden.wise.d03.com/public>
                Options +Indexes
        </Directory>

        Alias "/js" "/var/www/eden.wise.d03.com/public/js"

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        ErrorDocument 404 /error/404.html
</VirtualHost>
```
Copy file dengan command 
```
cp /root/default-wise-7.conf /etc/apache2/sites-available/eden.wise.d03.com.conf.
```

Restart apache   
```
service apache2 restart.
```

Testing pada node Garden dan SSS dengan command 
```lynx www.eden.wise.d03.com/public/images/abcedendef```  
maka akan muncul tampilan berikut.  
![17](https://user-images.githubusercontent.com/57696730/199225830-c06c2d9e-3e21-4deb-806f-9bb54c3c906f.png)





