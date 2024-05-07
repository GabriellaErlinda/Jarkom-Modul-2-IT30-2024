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
siren   IN      NS      ns1
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

echo 'options {
        directory "/var/cache/bind";

        dnssec-validation auto;
        allow-query{any;};

        auth-nxdomain no;
        listen-on-v6 { any; };
};' > /etc/bind/named.conf.options

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
echo 'nameserver 192.248.2.2
nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install apache2 -y

echo '<VirtualHost *:80>
    ServerName 192.248.2.2

    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > /etc/apache2/server-available/000-default.conf
service apache2 restart
}

# Lipovka - web server
Lipovka(){
echo 'nameserver 192.248.2.3
nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install apache2 -y

echo '<VirtualHost *:80>
    ServerName 192.248.2.4

    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > /etc/apache2/server-available/000-default.conf
service apache2 restart
}

# Stalber - web server
Stalber(){
echo 'nameserver 192.248.2.4
nameserver 192.168.122.1' > /etc/resolv.conf


apt-get update
apt-get install apache2 -y

echo '<VirtualHost *:80>
    ServerName 192.248.2.5

    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > /etc/apache2/server-available/000-default.conf
service apache2 restart

}

# Mylta - web server
Mylta(){
echo 'nameserver 192.248.2.5
nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install apache2 -y

apt-get install libapache2-mod-php7.0 -y
a2enmod proxy
a2enmod proxy_balancer
a2enmod proxy_http
a2enmod lbmethod_byrequests
a2enmod lbmethod_bytraffic
a2enmod rewrite
service apache2 restart

echo '<VirtualHost *:80>
    ServerName 192.248.2.5

    <Proxy balancer://roundrobin>
        BalancerMember http://192.248.2.2:80 
        BalancerMember http://192.248.2.3:80 
        BalancerMember http://192.248.2.4:80 
    </Proxy>

    <Proxy balancer://leastconn>
        BalancerMember http://192.248.2.2:80 
        BalancerMember http://192.248.2.3:80 
        BalancerMember http://192.248.2.4:80 
        ProxySet lbmethod=bytraffic
    </Proxy>

    <Proxy balancer://weightedrr>
        ProxySet lbmethod=byrequests
        ProxySet stickysession=ROUTEID
        BalancerMember http://192.248.2.2:80 
        BalancerMember http://192.248.2.3:80 
        BalancerMember http://192.248.2.4:80 
    </Proxy>

    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^roundrobin\.myIta$ [NC]
    RewriteRule ^/(.*)$ balancer://roundrobin/$1 [P,L]

    RewriteCond %{HTTP_HOST} ^leastconn\.myIta$ [NC]
    RewriteRule ^/(.*)$ balancer://leastconn/$1 [P,L]

    RewriteCond %{HTTP_HOST} ^weightedrr\.myIta$ [NC]
    RewriteRule ^/(.*)$ balancer://weightedrr/$1 [P,L]

    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

service apache2 restart

apt-get install nginx -y
mkdir /etc/nginx/jarkom2024
touch /etc/nginx/jarkom2024/load.conf

echo '
    upstream roundrobin_backend {
        server 192.248.2.2;
        server 192.248.2.3;
        server 192.248.2.4;
    }

    upstream leastconn_backend {
        least_conn;
        server 192.248.2.2;
        server 192.248.2.3;
        server 192.248.2.4;
    }

    upstream weightedrr_backend {
        server 192.248.2.2; weight=3
        server 192.248.2.3; weight=2
        server 192.248.2.4; weight=1
    }
'  > /etc/nginx/jarkom2024/load.conf

echo '
user       www www;  ## Default: nobody
worker_processes  5;  ## Default: 1
error_log  logs/error.log;
pid        logs/nginx.pid;
worker_rlimit_nofile 8192;

events {
  worker_connections  4096;  ## Default: 1024
}

http {
  include    conf/mime.types;
  include    /etc/nginx/proxy.conf;
  include    /etc/nginx/fastcgi.conf;
  include    /etc/nginx/jarkom2024/*.conf
  index    index.html index.htm index.php;

  default_type application/octet-stream;
  log_format   main '$remote_addr - $remote_user [$time_local]  $status '
    '"$request" $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log   logs/access.log  main;
  sendfile     on;
  tcp_nopush   on;
  server_names_hash_bucket_size 128; # this seems to be required for some vhosts

  server { # php/fastcgi
    listen       80;
    server_name  domain1.com www.domain1.com;
    access_log   logs/domain1.access.log  main;
    root         html;

    location ~ \.php$ {
      fastcgi_pass   127.0.0.1:1025;
    }
  }

  server { # simple reverse-proxy
    listen       80;
    server_name  domain2.com www.domain2.com;
    access_log   logs/domain2.access.log  main;

    # serve static files
    location ~ ^/(images|javascript|js|css|flash|media|static)/  {
      root    /var/www/virtual/big.server.com/htdocs;
      expires 30d;
    }

    # pass requests for dynamic content to rails/turbogears/zope, et al
    location / {
      proxy_pass      http://127.0.0.1:8080;
    }
  }

  upstream big_server_com {
    server 127.0.0.3:8000 weight=5;
    server 127.0.0.3:8001 weight=5;
    server 192.168.0.1:8000;
    server 192.168.0.1:8001;
  }

  server { # simple load balancing
    listen          80;
    server_name     big.server.com;
    access_log      logs/big.server.access.log main;

    location / {
      proxy_pass      http://big_server_com;
    }
  }
}' > /etc/nginx/nginx.conf

echo '
    upstream roundrobin_backend {
        server 192.248.2.2;
        server 192.248.2.3;
        server 192.248.2.4;
    }

    upstream leastconn_backend {
        least_conn;
        server 192.248.2.2;
        server 192.248.2.3;
        server 192.248.2.4;
    }

    upstream weightedrr_backend {
        server 192.248.2.2; weight=3
        server 192.248.2.3; weight=2
        server 192.248.2.4; weight=1
    }

' > /etc/nginx/jarkom2024/load.conf


echo '
    server {
        listen 80;
        server_name mynginx.example.com;

        location /roundrobin {
            proxy_pass http://roundrobin_backend;
        }

        location /leastconn {
            proxy_pass http://leastconn_backend;
        }

        location /weightedrr {
            proxy_pass http://weightedrr_backend;
        }
    }' > /etc/nginx/sites-available/default
service nginx reload

ab -n 1000 -c 100 http://roundrobin.myIta.com/
ab -n 1000 -c 100 http://leastconn.myIta.com/
ab -n 1000 -c 100 http://weightedrr.myIta.com/

mkdir /etc/apache2/worker2/resource

echo '<VirtualHost *:80>
    ServerName 192.248.2.5


    <Proxy balancer://roundrobin>
        BalancerMember http://192.248.2.2:80 
        BalancerMember http://192.248.2.3:80 
        BalancerMember http://192.248.2.4:80 
    </Proxy>

    <Proxy balancer://leastconn>
        BalancerMember http://192.248.2.2:80 
        BalancerMember http://192.248.2.3:80 
        BalancerMember http://192.248.2.4:80 
        ProxySet lbmethod=byrequests
    </Proxy>

    <Proxy balancer://weightedrr>
        BalancerMember http://192.248.2.2:80  
        BalancerMember http://192.248.2.3:80  
        BalancerMember http://192.248.2.4:80  
        ProxySet lbmethod=byrequests
        ProxySet stickysession=ROUTEID
    </Proxy>

    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^roundrobin\.myIta\.it30\.com$ [NC]
    RewriteRule ^/(.*)$ balancer://roundrobin/$1 [P,L]

    RewriteCond %{HTTP_HOST} ^leastconn\.myIta\.it30\.com$ [NC]
    RewriteRule ^/(.*)$ balancer://leastconn/$1 [P,L]

    RewriteCond %{HTTP_HOST} ^weightedrr\.myIta\.it30\.com$ [NC]
    RewriteRule ^/(.*)$ balancer://weightedrr/$1 [P,L]

    RewriteCond %{HTTP_HOST} ^192\.248\.2\.5$
    RewriteRule ^(.*)$ http://www.mylta.it30.com/$1 [L,R=301]
<VirtualHost *:14400>
    ServerName mylta.it30.com
    ServerAlias www.mylta.it30.com

    <Proxy balancer://myita_balancer>
        BalancerMember http://MyIta:14400
    </Proxy>

    ProxyPass / balancer://myita_balancer/
    ProxyPassReverse / balancer://myita_balancer/
</VirtualHost>
' > /etc/apache2/sites-available/000-default.conf

apt-get install lynx
lynx http://www.mylta.it30.com
lynx 192.248.2.5

echo '<VirtualHost *:80>
    ServerName 192.248.2.5


    <Proxy balancer://roundrobin>
        BalancerMember http://192.248.2.2:80 
        BalancerMember http://192.248.2.3:80 
        BalancerMember http://192.248.2.4:80 
    </Proxy>

    <Proxy balancer://leastconn>
        BalancerMember http://192.248.2.2:80 
        BalancerMember http://192.248.2.3:80 
        BalancerMember http://192.248.2.4:80 
        ProxySet lbmethod=byrequests
    </Proxy>

    <Proxy balancer://weightedrr>
        BalancerMember http://192.248.2.2:80  
        BalancerMember http://192.248.2.3:80  
        BalancerMember http://192.248.2.4:80  
        ProxySet lbmethod=byrequests
        ProxySet stickysession=ROUTEID
    </Proxy>

    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^roundrobin\.myIta\.it30\.com$ [NC]
    RewriteRule ^/(.*)$ balancer://roundrobin/$1 [P,L]

    RewriteCond %{HTTP_HOST} ^leastconn\.myIta\.it30\.com$ [NC]
    RewriteRule ^/(.*)$ balancer://leastconn/$1 [P,L]

    RewriteCond %{HTTP_HOST} ^weightedrr\.myIta\.it30\.com$ [NC]
    RewriteRule ^/(.*)$ balancer://weightedrr/$1 [P,L]

    RewriteCond %{HTTP_HOST} ^192\.248\.2\.5$
    RewriteRule ^(.*)$ http://www.mylta.it30.com/$1 [L,R=301]
<VirtualHost *:14400>
    ServerName mylta.it30.com
    ServerAlias www.mylta.it30.com

    <Proxy balancer://myita_balancer>
        BalancerMember http://MyIta:14400
    </Proxy>

    ProxyPass / balancer://myita_balancer/
    ProxyPassReverse / balancer://myita_balancer/
</VirtualHost>

<VirtualHost *:80>
    ServerName tamat.it30.com
    ServerAlias www.tamat.it30.com

    DocumentRoot /etc/apache2/worker2/resource
    <Directory /etc/apache2/worker2/resource>
        Options +Indexes
        IndexOptions FancyIndexing HTMLTable NameWidth=* DescriptionWidth=*
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

mkdir /etc/apache2/worker2
mkdir -p /etc/apache2/worker2/resource
curl -I http://tamat.it30.com
curl -I http://www.tamat.it30.com
ls
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