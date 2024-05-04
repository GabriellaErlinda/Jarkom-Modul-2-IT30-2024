#!/bin/bash

# ERANGEL - router
Erangel(){
    apt-get update
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.248.0.0/16
}

# POCHINKI - DNS Master
Pochinki(){
# To Erangel
echo 'nameserver 192.168.122.1' > /etc/resolv.conf

# Install bind9
apt-get update
apt-get install bind9 -y

# Edit named.conf.local
echo 'zone "airdrop.it30.com" {
    type master;
    also-notify { 192.248.4.2; };
    allow-transfer { 192.248.4.2; };
    file "/etc/bind/airdrop/airdrop.it30.com";
};

zone "redzone.it30.com" {
    type master;
    also-notify { 192.248.4.2; };
    allow-transfer { 192.248.4.2; };
    file "/etc/bind/redzone/redzone.it30.com";
};

zone "loot.it30.com" {
    type master;
    also-notify { 192.248.4.2; };
    allow-transfer { 192.248.4.2; };
    file "/etc/bind/loot/loot.it30.com";
};

zone "2.248.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/2.248.192.in-addr.arpa";
};' > /etc/bind/named.conf.local

# Membuat folder di dalam /etc/bind
mkdir /etc/bind/airdrop
mkdir /etc/bind/redzone
mkdir /etc/bind/loot
mkdir /etc/bind/jarkom
mkdir /etc/bind/siren

# Menyalin file db.local
cp /etc/bind/db.local /etc/bind/airdrop/airdrop.it30.com
cp /etc/bind/db.local /etc/bind/redzone/redzone.it30.com
cp /etc/bind/db.local /etc/bind/loot/loot.it30.com
cp /etc/bind/db.local /etc/bind/jarkom/2.248.192.in-addr.arpa #Reverse DNS Severny

# Edit file /etc/bind/airdrop/airdrop.it30.com
echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     airdrop.it30.com. root.airdrop.it30.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      airdrop.it30.com.
@       IN      A       192.248.2.4 ; IP Stalber
www     IN      CNAME   airdrop.it30.com.
medkit  IN      A       192.248.2.3 ; IP Lipovka
@       IN      AAAA    ::1' > /etc/bind/airdrop/airdrop.it30.com

# Edit file /etc/bind/redzone/redzone.it30.com
echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     redzone.it30.com. root.redzone.it30.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      redzone.it30.com.
@       IN      A       192.248.2.2
@       IN      AAAA    ::1
www     IN      CNAME   redzone.it30.com.' > /etc/bind/redzone/redzone.it30.com

# Edit file /etc/bind/loot/loot.it30.com
echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     loot.it30.com. root.loot.it30.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      loot.it30.com.
@       IN      A       192.248.2.5
@       IN      AAAA    ::1
www     IN      CNAME   loot.it30.com.' > /etc/bind/loot/loot.it30.com

# Edit file /etc/bind/jarkom/2.248.192.in-addr.arpa
echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     redzone.it30.com. root.redzone.it30.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
2.248.192.in-addr.arpa  IN      NS      redzone.it30.com.
2                       IN      PTR     redzone.it30.com.' > /etc/bind/loot/loot.it30.com

# Menyalin file redzone ke siren
cp /etc/bind/redzone/redzone.it30.com /etc/bind/siren/siren.redzone.it30.com


# Edit file /etc/bind/siren/siren.redzone.it30.com
echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     redzone.it30.com. root.redzone.it30.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      redzone.it30.com.
@       IN      A       192.248.2.2 ; IP Severny
www     IN      CNAME   redzone.it30.com.
siren   IN      A       192.248.4.2 ; IP Georgopol
ns1     IN      A       192.248.4.2 ; IP Georgopol
its     IN      NS      ns1
@       IN      AAAA    ::1' > /etc/bind/siren/siren.redzone.it30.com

echo 'options {
        directory "/var/cache/bind";

        forwarders {
            192.168.122.1;
        }

        //dnssec-validation auto;
        allow-query{any;};

        auth-nxdomain no;
        listen-on-v6 { any; };
};' > /etc/bind/named.conf.options

# Restart bind9
service bind9 restart
}

# GEORGOPOL - DNS Slave
Georgopol(){
echo 'nameserver 192.248.3.2
nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

echo 'zone "airdrop.it30.com" {
    type slave;
    masters { 192.248.3.2; };
    file "/var/lib/bind/airdrop.it30.com";
};

zone "redzone.it30.com" {
    type slave;
    masters { 192.248.3.2; };
    file "/var/lib/bind/redzone.it30.com";
};

zone "loot.it30.com" {
    type slave;
    masters { 192.248.3.2; };
    file "/var/lib/bind/loot.it30.com";
};

zone "siren.redzone.it30.com" {
    type master;
    file "/etc/bind/siren/siren.redzone.it30.com";
};' > /etc/bind/named.conf.local

mkdir /etc/bind/siren
cp /etc/bind/db.local /etc/bind/siren/siren.redzone.it30.com

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     siren.redzone.it30.com. root.siren.redzone.it30.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      siren.redzone.it30.com.
@       IN      A       192.248.4.2 ; IP Georgopol
www     IN      CNAME   siren.redzone.it30.com.
log     IN      A       192.248.4.2 ; IP Georgopol
www.log IN      CNAME   siren.redzone.it30.com
@       IN      AAAA    ::1' > /etc/bind/siren/siren.redzone.it30.com

service bind9 restart
}

# Zharki - client
Zharki(){
echo 'nameserver 192.248.122.1' > /etc/resolv.conf

apt-get update
apt-get install dnsutils -y

echo 'nameserver 192.248.3.2
nameserver 192.248.4.2' > /etc/resolv.conf

host -t PTR 192.248.2.2
}

# YasnayaPolyana - client
YasnayaPolyana(){
echo 'nameserver 192.248.122.1' > /etc/resolv.conf

apt-get update
apt-get install dnsutils -y

echo 'nameserver 192.248.3.2
nameserver 192.248.4.2' > /etc/resolv.conf

host -t PTR 192.248.2.2
}

# Primorsk - client
Primorsk(){
echo 'nameserver 192.248.122.1' > /etc/resolv.conf

apt-get update
apt-get install dnsutils -y

echo 'nameserver 192.248.3.2
nameserver 192.248.4.2' > /etc/resolv.conf

host -t PTR 192.248.2.2
}

# Severny - web server
Severny(){
echo 'nameserver 192.248.3.2' > /etc/resolv.conf
}

# Lipovka - web server
Lipovka(){
echo 'nameserver 192.248.3.2' > /etc/resolv.conf
}

# Stalber - web server
Stalber(){
echo 'nameserver 192.248.3.2' > /etc/resolv.conf
}

# Mylta - web server
Mylta(){
echo 'nameserver 192.248.3.2' > /etc/resolv.conf
}



if [ $HOSTNAME == "Erangel" ]
then
    Erangel
elif [ $HOSTNAME == "Pochinki" ]
then
    Pochinki
elif [ $HOSTNAME == "Georgopol" ]
then
    Georgopol
elif [ $HOSTNAME == "Zharki" ]
then
    Zharki
elif [ $HOSTNAME == "YasnayaPolyana" ]
then
    YasnayaPolyana
elif [ $HOSTNAME == "Primorsk" ]
then
    Primorsk
elif [ $HOSTNAME == "Severny" ]
then
    Severny
elif [ $HOSTNAME == "Lipovka" ]
then
    Lipovka
elif [ $HOSTNAME == "Stalber" ]
then
    Stalber
elif [ $HOSTNAME == "Mylta" ]
then
    Mylta
fi
