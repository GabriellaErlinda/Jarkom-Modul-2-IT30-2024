# Lapres-Jarkom-Modul-1-IT30-2024

## Anggota

| Nama                            | NRP          |
| ------------------------------- | ------------ |
| Gabriella Erlinda Wijaya        | `5027221018` |
| Aras Rizky Ananta               | `5027221053` |


## SOAL 1
> Untuk membantu pertempuran di Erangel, kamu ditugaskan untuk membuat jaringan komputer yang akan digunakan sebagai alat komunikasi. Sesuaikan rancangan Topologi dengan rancangan dan pembagian yang berada di link yang telah disediakan, dengan ketentuan nodenya sebagai berikut :
> - DNS Master akan diberi nama `Pochinki`, sesuai dengan kota tempat dibuatnya server tersebut
> - Karena ada kemungkinan musuh akan mencoba menyerang Server Utama, maka buatlah DNS Slave `Georgopol` yang mengarah ke Pochinki
> - Markas pusat juga meminta dibuatkan tiga Web Server yaitu `Severny, Stalber, dan Lipovka`. Sedangkan `Mylta` akan bertindak sebagai Load Balancer untuk server-server tersebut

### Topologi Jaringan
![Screenshot 2024-05-02 184745](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/9c2350ac-87da-4f1a-878c-861497e64af9)

#### Network Configuration
#### Erangel
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.248.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.248.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.248.3.1
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 192.248.4.1
	netmask 255.255.255.0
```
#### Pochinki (DNS Master)
```
auto eth0
iface eth0 inet static
    address 192.248.3.2
    netmask 255.255.255.0
    gateway 192.248.3.1
```
#### Georgopol (DNS Slave)
```
auto eth0
iface eth0 inet static
    address 192.248.4.2
    netmask 255.255.255.0
    gateway 192.248.4.1
```
#### Severny (Web Server)
```
auto eth0
iface eth0 inet static
    address 192.248.2.2
    netmask 255.255.255.0
    gateway 192.248.2.1
```

#### Lipovka (Web Server)
```
auto eth0
iface eth0 inet static
    address 192.248.2.3
    netmask 255.255.255.0
    gateway 192.248.2.1
```

#### Stalber (Web Server)
```
auto eth0
iface eth0 inet static
    address 192.248.2.4
    netmask 255.255.255.0
    gateway 192.248.2.1
```

#### Mylta (Load Balancer)
```
auto eth0
iface eth0 inet static
    address 192.248.2.5
    netmask 255.255.255.0
    gateway 192.248.2.1
```

#### Zharki (Client)
```
auto eth0
iface eth0 inet static
    address 192.248.1.2
    netmask 255.255.255.0
    gateway 192.248.1.1
```

#### YasnayaPolyana (Client)
```
auto eth0
iface eth0 inet static
    address 192.248.1.3
    netmask 255.255.255.0
    gateway 192.248.1.1
```

#### Primorsk (Client)
```
auto eth0
iface eth0 inet static
    address 192.248.1.4
    netmask 255.255.255.0
    gateway 192.248.1.1
```

Pada Erangel, cek `ip a` untuk melihat apakah semua config sudah sesuai IP Prefix.

Pada Erangel dijalankan command berikut untuk mengatur semua lalu lintas dalam komputer, `MASQUERADE` digunakan untuk menyamarkan paket, dan `-s` untuk menspesifikasikan pada source IP nya
```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.248.0.0/16
```
Ketikkan command `cat /etc/resolv.conf` pada Erangel
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/f813ec50-abe0-4c3a-8bac-3f9a19c9ae40)

Ketikkan command ini pada Pochinki, `echo nameserver [IP DNS] > /etc/resolv.conf`. Pada kasus ini maka command-nya adalah `echo nameserver 192.168.122.1 > /etc/resolv.conf`.

Untuk node yang lain, gunakan command `echo nameserver [IP DNS] > /etc/resolv.conf` dengan IP Pochinki yaitu `192.248.3.2`. Maka command nya adalah `echo nameserver 192.248.3.2 > /etc/resolv.conf`

Pada Pochinki jalankan command `apt-get update` lalu `apt-get install bind9 -y` untuk install bind9.

## SOAL 2
> Karena para pasukan membutuhkan koordinasi untuk mengambil airdrop, maka buatlah sebuah domain yang mengarah ke Stalber dengan alamat airdrop.xxxx.com dengan alias www.airdrop.xxxx.com dimana xxxx merupakan kode kelompok. Contoh : airdrop.it30.com

#### Pembuatan Domain
Lakukan command berikut pada Pochinki untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

Isikan configurasi domain airdrop.it30.com
```
zone "airdrop.it30.com" {
	type master;
	file "/etc/bind/airdrop/airdrop.it30.com";
};
```

Buat folder airdrop di dalam /etc/bind
```
mkdir /etc/bind/airdrop
```

Copy file db.local di /etc/bind ke folder airdrop, ubah namanya sesuai nama domain
```
cp /etc/bind/db.local /etc/bind/airdrop/airdrop.it30.com
```

Buka file airdrop.it30.com dengan `nano /etc/bind/airdrop/airdrop.it30.com` dan edit seperti ini
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/bb33aa70-541a-4907-80d6-4142133f01c6)

Restart bind9 dengan `service bind9 restart`

## SOAL 3
> Para pasukan juga perlu mengetahui mana titik yang sedang di bombardir artileri, sehingga dibutuhkan domain lain yaitu redzone.xxxx.com dengan alias www.redzone.xxxx.com yang mengarah ke Severny

#### Pembuatan Domain
Lakukan command berikut pada Pochinki untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

Isikan configurasi domain redzone.it30.com
```
zone "redzone.it30.com" {
	type master;
	file "/etc/bind/redzone/redzone.it30.com";
};
```

Buat folder airdrop di dalam /etc/bind
```
mkdir /etc/bind/redzone
```

Copy file db.local di /etc/bind ke folder airdrop, ubah namanya sesuai nama domain
```
cp /etc/bind/db.local /etc/bind/redzone/redzone.it30.com
```

Buka file redzone.it30.com dengan `nano /etc/bind/redzone/redzone.it30.com` dan edit seperti ini
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/0800e8c4-dd0c-45e2-98bf-d7722edfb9a5)

Restart bind9 dengan `service bind9 restart`

## SOAL 4
> Markas pusat meminta dibuatnya domain khusus untuk menaruh informasi persenjataan dan suplai yang tersebar. Informasi persenjataan dan suplai tersebut mengarah ke Mylta dan domain yang ingin digunakan adalah loot.xxxx.com dengan alias www.loot.xxxx.com

#### Pembuatan Domain
Lakukan command berikut pada Pochinki untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

Isikan configurasi domain redzone.it30.com
```
zone "loot.it30.com" {
	type master;
	file "/etc/bind/loot/loot.it30.com";
};
```

Buat folder airdrop di dalam /etc/bind
```
mkdir /etc/bind/loot
```

Copy file db.local di /etc/bind ke folder airdrop, ubah namanya sesuai nama domain
```
cp /etc/bind/db.local /etc/bind/loot/loot.it30.com
```

Buka file loot.it30.com dengan `nano /etc/bind/loot/loot.it30.com` dan edit seperti ini
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/71d0c88b-d17c-4acf-b6a2-01dd1176d68e)

Restart bind9 dengan `service bind9 restart`


## SOAL 5
Untuk memastikan bahwa semua komputer (client) dapat mengakses domain yang telah dibuat, jalankan command `ping [domain]` pada setiap komputer

- Zharki
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/d1fed4f0-c9c2-4530-8171-6f07c555d791)

- YasnayaPolyana
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/4168e968-a0a5-4ac5-921a-c2f76d754f23)

- Primorsk
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/80d23d52-c6f3-4567-9321-a45c231fc8cc)


## SOAL 6
> Beberapa daerah memiliki keterbatasan yang menyebabkan hanya dapat mengakses domain secara langsung melalui alamat IP domain tersebut. Karena daerah tersebut tidak diketahui secara spesifik, pastikan semua komputer (client) dapat mengakses domain redzone.xxxx.com melalui alamat IP Severny (Notes : menggunakan pointer record)

Lakukan command berikut pada Pochinki untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

Lalu tambahkan konfigurasi berikut ke dalam file `named.conf.local`. Tambahkan reverse dari 3 byte awal dari IP Severny yaitu `192.248.2.2`, maka reverse 3 byte awalnya `2.248.192`.
```
zone "2.248.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/2.248.192.in-addr.arpa";
};
```

Buat direktori jarkom
```
mkdir /etc/bind/jarkom
```

Copy file db.local di /etc/bind ke folder jarkom, ubah namanya menjadi `2.248.192.in-addr.arpa`
```
cp /etc/bind/db.local /etc/bind/jarkom/2.248.192.in-addr.arpa
```

Buka file 2.248.192.in-addr.arpa dengan `nano /etc/bind/jarkom/2.248.192.in-addr.arpa` dan edit seperti ini
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/2a7b8587-bacb-4d63-9931-ee8979941cf6)

Restart bind9 dengan `service bind9 restart`

Untuk mengecek apakah konfigurasi sudah benar atau belum, pertama kembalikan nameserver client ke Erangel dengan `echo nameserver 192.168.122.1 > /etc/resolv.conf`, lalu lakukan command ini untuk setiap client
```
apt-get update
apt-get install dnsutils
```
Lalu kembalikan nameserver ke Pochinki dengan `echo nameserver 192.248.3.2 > /etc/resolv.conf`
Jalankan command
```
host -t PTR 192.248.2.2
```
- Zharki
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/eab4d58e-6239-4f95-8ec1-384cbf9574cc)

- YasnayaPolyana
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/8dec5191-ed02-45f5-908a-bb7f141c4a16)

- Primorsk
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/54088eb4-c115-4461-beca-2fba6fea3168)


## SOAL 7
> Akhir-akhir ini seringkali terjadi serangan siber ke DNS Server Utama, sebagai tindakan antisipasi kamu diperintahkan untuk membuat DNS Slave di Georgopol untuk semua domain yang sudah dibuat sebelumnya

### Pochinki
Lakukan command berikut untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

Edit konfigurasi untuk setiap domain menjadi seperti ini, dimana `192.248.4.2` adalah IP Georgopol yang akan dijadikan DNS Slave
```
zone "airdrop.it30.com" {
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
```
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/eb07d75d-5c2c-41b6-96f1-3e60f4d48a2a)

Restart bind9 dengan `service bind9 restart`

### Georgopol
Pastikan Georgopol terhubung dengan internet menggunakan `echo nameserver 192.168.122.1 > /etc/resolv.conf` dimana `192.168.122.1` adalah IP Erangel

Jalankan command berikut
```
apt-get update
apt-get install bind9 -y
```

Lakukan command berikut untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

Buka file dengan `nano /etc/bind/named.conf.local`. Tambahkan konfigurasi berikut pada file tersebut
```
zone "airdrop.it30.com" {
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
```

Restart bind9 dengan `service bind9 restart`

### Testing
- Matikan bind9 pada DNS Master atau Pochinki
```
service bind9 stop
```

- Lakukan command berikut untuk semua client (Zharki, YasnayaPolyana, Primorsk)
```
nano /etc/resolv.conf
```

- Edit Konfigurasi untuk semua file `resolv.conf` pada setiap client
```
nameserver 192.248.3.2 #IP Pochinki
nameserver 192.248.4.2 #IP Georgopol
```
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/c2dfdd34-8c76-4ca4-b012-de83c180ad94)

- Test dengan ping ke domain-domain yang telah dibuat tadi
- Zharki
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/56f08a09-d656-454a-a9fc-45be0d419037)
- YasnayaPolyana
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/403d0654-d264-45fb-9bfb-28f66e4989c5)
- Primorsk
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/fa41f398-aa02-4fb0-b2e5-91bdc3d54a11)

Terlihat semua client berhasil melakukan ping ke semua domain, tandanya konfigurasi DNS Slave telah berhasil


## SOAL 8
> Kamu juga diperintahkan untuk membuat subdomain khusus melacak airdrop berisi peralatan medis dengan subdomain medkit.airdrop.xxxx.com yang mengarah ke Lipovka

#### Membuat subdomain
- Pada **Pochinki**, buka file airdrop.it30.com dengan `nano /etc/bind/airdrop/airdrop.it30.com`
- Tambahkan konfigurasi untuk subdomain seperti ini
```
;
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
@       IN      A       192.248.2.4
@       IN      AAAA    ::1
www     IN      CNAME   airdrop.it30.com.
medkit  IN      A       192.248.2.3
```
Restart bind9 dengan `service bind9 restart`

- Zharki
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/ea4d5638-f12f-45f2-98b3-150ec04924af)
- YasnayaPolyana
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/9557d22f-0d0d-4acf-8662-bf93dd15a9af)
- Primorsk
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/2e7329fc-51ca-4588-93b0-72eab0ab8977)

## SOAL 9
> Terkadang red zone yang pada umumnya di bombardir artileri akan dijatuhi bom oleh pesawat tempur. Untuk melindungi warga, kita diperlukan untuk membuat sistem peringatan air raid dan memasukkannya ke domain siren.redzone.xxxx.com dalam folder siren dan pastikan dapat diakses secara mudah dengan menambahkan alias www.siren.redzone.xxxx.com dan mendelegasikan subdomain tersebut ke Georgopol dengan alamat IP menuju radar di Severny

### Konfigurasi Pochinki
`mkdir /etc/bind/siren`
`cp /etc/bind/redzone/redzone.it30.com /etc/bind/siren/siren.redzone.it30.com`
`nano /etc/bind/siren/siren.redzone.it30.com`
```
;
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
@       IN      AAAA    ::1
```
Edit file `etc/bind/named.conf.options` pada Pochinki
```
nano /etc/bind/named.conf.options
```
Tambahkan line berikut
```
allow-query{any;};
```
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/78433e73-defb-4abc-a9de-a39a43030ca6)

Restart bind9 dengan `service bind9 restart`

#### Konfigurasi Georgopol
- Edit file `/etc/bind/named.conf.options` pada Georgopol
```
nano /etc/bind/named.conf.options
```

- Tambahkan line berikut
```
allow-query{any;};
```

- Buka dan edit file `/etc/bind/named.conf.local`, tambahkan konfigurasi di bawah ini
```
zone "siren.redzone.it30.com" {
    type master;
    file "/etc/bind/siren/siren.redzone.it30.com";
};
```

- Buat folder siren dan copy `db.local` ke `siren.redzone.it30.com`
```
mkdir /etc/bind/siren
cp /etc/bind/db.local /etc/bind/siren/siren.redzone.it30.com
```

Buka dan edit file `/etc/bind/siren/siren.redzone.it30.com`
```
;
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
@       IN      AAAA    ::1
```

Restart bind9 dengan `service bind9 restart`


#### Testing
- Zharki
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/b6a44a24-bc48-4ec9-96e6-fefa34ff4b12)
- YasnayaPolyana
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/1c117331-71eb-49d4-a20d-e6c73781309e)
- Primorsk
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/65e68db4-b008-466f-9ce5-3f92d76ed6cd)
