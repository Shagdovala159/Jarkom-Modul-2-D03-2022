;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     wise.d03.com. root.wise.d03.com. (
                        4               ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      wise.d03.com.
@       IN      A       192.186.2.3
www     IN      CNAME   wise.d03.com.
eden   IN      A       192.186.2.3
www.eden IN    CNAME   eden.wise.d03.com.
operation   IN      NS      ns1