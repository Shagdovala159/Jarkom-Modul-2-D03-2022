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
strix IN      A       192.186.2.3
www.strix IN  CNAME   strix.operation.wise.d03.com.