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

#### Set Up
- Pada Erangel, cek `ip a` untuk melihat apakah semua config sudah sesuai IP Prefix.
- Pada Erangel dijalankan command berikut untuk mengatur semua lalu lintas dalam komputer, `MASQUERADE` digunakan untuk menyamarkan paket, dan `-s` untuk menspesifikasikan pada source IP nya
```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.248.0.0/16
```
- Ketikkan command `cat /etc/resolv.conf` pada Erangel
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/f813ec50-abe0-4c3a-8bac-3f9a19c9ae40)

- Ketikkan command ini pada Pochinki, `echo nameserver [IP DNS] > /etc/resolv.conf`. Pada kasus ini maka command-nya adalah `echo nameserver 192.168.122.1 > /etc/resolv.conf`.

- Untuk node yang lain, gunakan command `echo nameserver [IP DNS] > /etc/resolv.conf` dengan IP Pochinki yaitu `192.248.3.2`. Maka command nya adalah `echo nameserver 192.248.3.2 > /etc/resolv.conf`

- Pada Pochinki jalankan command `apt-get update` lalu `apt-get install bind9 -y` untuk install bind9.

## SOAL 2
> Karena para pasukan membutuhkan koordinasi untuk mengambil airdrop, maka buatlah sebuah domain yang mengarah ke Stalber dengan alamat airdrop.xxxx.com dengan alias www.airdrop.xxxx.com dimana xxxx merupakan kode kelompok. Contoh : airdrop.it30.com

#### Pembuatan Domain
- Lakukan command berikut pada Pochinki untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

- Isikan configurasi domain airdrop.it30.com
```
zone "airdrop.it30.com" {
	type master;
	file "/etc/bind/airdrop/airdrop.it30.com";
};
```

- Buat folder airdrop di dalam /etc/bind
```
mkdir /etc/bind/airdrop
```

- Copy file db.local di /etc/bind ke folder airdrop, ubah namanya sesuai nama domain
```
cp /etc/bind/db.local /etc/bind/airdrop/airdrop.it30.com
```

- Buka file airdrop.it30.com dengan `nano /etc/bind/airdrop/airdrop.it30.com` dan edit seperti ini
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/bb33aa70-541a-4907-80d6-4142133f01c6)

Restart bind9 dengan `service bind9 restart`

## SOAL 3
> Para pasukan juga perlu mengetahui mana titik yang sedang di bombardir artileri, sehingga dibutuhkan domain lain yaitu redzone.xxxx.com dengan alias www.redzone.xxxx.com yang mengarah ke Severny

#### Pembuatan Domain
- Lakukan command berikut pada Pochinki untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

- Isikan configurasi domain redzone.it30.com
```
zone "redzone.it30.com" {
	type master;
	file "/etc/bind/redzone/redzone.it30.com";
};
```

- Buat folder airdrop di dalam /etc/bind
```
mkdir /etc/bind/redzone
```

- Copy file db.local di /etc/bind ke folder airdrop, ubah namanya sesuai nama domain
```
cp /etc/bind/db.local /etc/bind/redzone/redzone.it30.com
```

- Buka file redzone.it30.com dengan `nano /etc/bind/redzone/redzone.it30.com` dan edit seperti ini
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/0800e8c4-dd0c-45e2-98bf-d7722edfb9a5)

Restart bind9 dengan `service bind9 restart`

## SOAL 4
> Markas pusat meminta dibuatnya domain khusus untuk menaruh informasi persenjataan dan suplai yang tersebar. Informasi persenjataan dan suplai tersebut mengarah ke Mylta dan domain yang ingin digunakan adalah loot.xxxx.com dengan alias www.loot.xxxx.com

#### Pembuatan Domain
- Lakukan command berikut pada Pochinki untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

- Isikan configurasi domain redzone.it30.com
```
zone "loot.it30.com" {
	type master;
	file "/etc/bind/loot/loot.it30.com";
};
```

- Buat folder airdrop di dalam /etc/bind
```
mkdir /etc/bind/loot
```

- Copy file db.local di /etc/bind ke folder airdrop, ubah namanya sesuai nama domain
```
cp /etc/bind/db.local /etc/bind/loot/loot.it30.com
```

- Buka file loot.it30.com dengan `nano /etc/bind/loot/loot.it30.com` dan edit seperti ini
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

- Lakukan command berikut pada Pochinki untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

- Lalu tambahkan konfigurasi berikut ke dalam file `named.conf.local`. Tambahkan reverse dari 3 byte awal dari IP Severny yaitu `192.248.2.2`, maka reverse 3 byte awalnya `2.248.192`.
```
zone "2.248.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/2.248.192.in-addr.arpa";
};
```

- Buat direktori jarkom
```
mkdir /etc/bind/jarkom
```

- Copy file `db.local` di `/etc/bind ke folder jarkom`, ubah namanya menjadi `2.248.192.in-addr.arpa`
```
cp /etc/bind/db.local /etc/bind/jarkom/2.248.192.in-addr.arpa
```

- Buka file 2.248.192.in-addr.arpa dengan `nano /etc/bind/jarkom/2.248.192.in-addr.arpa` dan edit seperti ini
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/2a7b8587-bacb-4d63-9931-ee8979941cf6)

Restart bind9 dengan `service bind9 restart`

- Untuk mengecek apakah konfigurasi sudah benar atau belum, pertama kembalikan nameserver client ke Erangel dengan `echo nameserver 192.168.122.1 > /etc/resolv.conf`, lalu lakukan command ini untuk setiap client
```
apt-get update
apt-get install dnsutils
```
- Lalu kembalikan nameserver ke Pochinki dengan `echo nameserver 192.248.3.2 > /etc/resolv.conf`
- Jalankan command
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
- Lakukan command berikut untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

- Edit konfigurasi untuk setiap domain menjadi seperti ini, dimana `192.248.4.2` adalah IP Georgopol yang akan dijadikan DNS Slave
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
- Pastikan Georgopol terhubung dengan internet menggunakan `echo nameserver 192.168.122.1 > /etc/resolv.conf` dimana `192.168.122.1` adalah IP Erangel

- Jalankan command berikut
```
apt-get update
apt-get install bind9 -y
```

- Lakukan command berikut untuk mengedit file `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```

- Buka file dengan `nano /etc/bind/named.conf.local`. Tambahkan konfigurasi berikut pada file tersebut
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

Buka dan edit file `/etc/bind/named.conf.local` menjadi seperti ini:
```
zone "siren.redzone.it30.com" {
    type master;
    file "/etc/bind/siren/siren.redzone.it30.com";
    allow-transfer { 192.248.4.2; };
};
```

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
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/04f7be7a-4362-492b-ba2e-b511e8a328ff)

- Buka dan edit file `/etc/bind/named.conf.local`, tambahkan konfigurasi di bawah ini
```
zone "siren.redzone.it30.com" {
    type master;
    file "/etc/bind/siren/siren.redzone.it30.com";
};
```
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/eb8c1bf5-6b24-4cd5-a980-abccf9b23de2)

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
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/8dd52e8e-9ff5-45eb-98d0-792db3b36815)

Restart bind9 dengan `service bind9 restart`


#### Testing
- Zharki
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/b6a44a24-bc48-4ec9-96e6-fefa34ff4b12)
- YasnayaPolyana
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/1c117331-71eb-49d4-a20d-e6c73781309e)
- Primorsk
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/65e68db4-b008-466f-9ce5-3f92d76ed6cd)


## SOAL 10
> Markas juga meminta catatan kapan saja pesawat tempur tersebut menjatuhkan bom, maka buatlah subdomain baru di subdomain siren yaitu log.siren.redzone.xxxx.com serta aliasnya www.log.siren.redzone.xxxx.com yang juga mengarah ke Severny

- Pada Georgopol, buka dan edit file `/etc/bind/siren/siren.redzone.it30.com` seperti di bawah ini untuk menambahkan subdomain `www.log.siren.redzone.it30.com`
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/75e83bae-8615-4177-9c9c-f4404bf44b47)

Restart bind9 dengan `service bind9 restart`

- Zharki
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/dbc7c67d-ea38-45b0-9f0e-578ba96dc1c7)
- YasnayaPolyana
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/2be48b59-64bd-49c8-8853-be4c4c8f5490)
- Primorsk
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/ef740290-730d-41dc-9ad6-e1ccedf67e20)


## SOAL 11
> Setelah pertempuran mereda, warga Erangel dapat kembali mengakses jaringan luar, tetapi hanya warga Pochinki saja yang dapat mengakses jaringan luar secara langsung. Buatlah konfigurasi agar warga Erangel yang berada diluar Pochinki dapat mengakses jaringan luar melalui DNS Server Pochinki

Buka dan edit file : `nano /etc/bind/named.conf.options`

- Uncomment bagian berikut dan ganti dengan IP nameserver Erangel
```
forwarders {
    192.168.122.1;
};
```
- Comment pada bagian ini
```
// dnssec-validation auto;
```
- Kemudian tambahkan
```
allow-query{any;};
```
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/4f9f3d61-e639-485b-b315-e025cac0fd72)

- Restart bind9 dengan `service bind9 restart`

- Pada node lain, ubah nameserver ke `IP Pochinki` saja pada `/etc/resolv.conf`, lalu coba `ping google.com`
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/8326f24e-7e82-4d93-88ca-21ff35f097eb)

#### Testing
- Zharki
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/857b6337-38e0-46ab-bc52-d92cc827704f)
- YasnayaPolyana
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/04355e65-8d42-4ac8-9a5d-4f9e30fad557)
- Primorsk
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/ab6bc50d-dff4-451a-a654-e82c6b47372e)
- Severny
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/c3bc1147-4e9b-4192-a622-060c4d24d80a)
- Lipovka
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/9e928763-f60c-46ed-9135-73ab9ed448a9)
- Stalber
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/471f3484-cbfc-4cd4-8813-a8d743ab783b)
- Mylta
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/53eb571b-38dd-4901-9cdf-71c42a99b26a)


## SOAL 12
> Karena pusat ingin sebuah website yang ingin digunakan untuk memantau kondisi markas lainnya maka deploy lah webiste ini (cek resource yg lb) pada severny menggunakan apache

Install apache2 di pochinki ```apt-get install apache2 -y```

-Tambahkan kode ini di apache2 000-default.conf
```

    ProxyPass /airdrop http://airdrop.it30.com
    ProxyPassReverse /airdrop http://airdrop.it30.com

    ProxyPass /redzone http://redzone.it30.com
    ProxyPassReverse /redzone http://redzone.it30.com

    ProxyPass /loot http://loot.it30.com
    ProxyPassReverse /loot http://loot.it30.com

    ProxyPass /siren http://siren.redzone.it30.com
    ProxyPassReverse /siren http://siren.redzone.it30.com

    ProxyPass /medikit http://medkit.airdrop.xxxx.com
    ProxyPassReverse /medikit http://medkit.airdrop.xxxx.com
```

![gabar3](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-08%20212558.png)
![gmba4](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-08%20212646.png)


## SOAL 13
>Tapi pusat merasa tidak puas dengan performanya karena traffic yag tinggi maka pusat meminta kita memasang load balancer pada web nya, dengan Severny, Stalber, Lipovka sebagai worker dan Mylta sebagai Load Balancer menggunakan apache sebagai web server nya dan load balancernya

-Sebelum memulai modifikasi file .config harus dulu diawali dengan menginstall apache2 pada Severny,Stalber,Lipovka,dan MyIta
```
apt-get update
apt-get install apache2 -y
```
-Kedua,masuk ke masing masing file config dan uncomment ServerName dan ganti example ke [Prefix IP].2.x
```
nano /etc/apache2/sites-available/000-default.conf
service apache2 restart
```
![gaba1](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-06%20224138.png)
![gabar2](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-06%20224254.png)
![gmba3](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-06%20225239.png)
![gambling4](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-06%20225348.png)
![gbaam5](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-06%20231548.png)

Hasil
![gaba2](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-08%20153229.png)
![gabar3](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-08%20153426.png)
## SOAL 14
>Mereka juga belum merasa puas jadi pusat meminta agar web servernya dan load balancer nya diubah menjadi nginx
```
apt-get update
apt-get install nginx
```
-Pertama,buat folder dan file config baru untuk menyimpan load manager
```
nano /etc/nginx/jarkom2024/load.conf
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

```
-Kedua,tambah line include di nginx.conf
```
nano /etc/nginx/nginx.conf


'include    /etc/nginx/jarkom2024/*.conf'
```
![gambar line](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-07%20202358.png)
-Tambah link baru untuk algoritma
```
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
	}
```
```
service nginx restart
```
###  SOAL 15
>Markas pusat meminta laporan hasil benchmark dengan menggunakan apache benchmark dari load balancer dengan 2 web server yang berbeda tersebut dan meminta secara detail dengan ketentuan:
>	-Nama Algoritma Load Balancer
>	-Report hasil testing apache benchmark 
>	-Grafik request per second untuk masing masing algoritma. 
>	-Analisis

Install
```
apt-get update
apt-get install libapache2-mod-php7.0 -y
a2enmod proxy
a2enmod proxy_balancer
a2enmod proxy_http
a2enmod lbmethod_byrequests
a2enmod lbmethod_bytraffic
a2enmod rewrite
service apache2 restart
```
-Buat load manager
```
<VirtualHost *:80>
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
</VirtualHost>
```
-Tes
```
ab -n 1000 -c 100 http://roundrobin.myIta.com/
ab -n 1000 -c 100 http://leastconn.myIta.com/
ab -n 1000 -c 100 http://weightedrr.myIta.com/
```
### SOAL 16
>Karena dirasa kurang aman karena masih memakai IP, markas ingin akses ke mylta memakai mylta.xxx.com dengan alias www.mylta.xxx.com (sesuai web server terbaik hasil analisis kalian)
```
    ServerAlias www.mylta.it30.com
```
![magi1](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-07%20144802.png)
### SOAL 17
>Agar aman, buatlah konfigurasi agar mylta.xxx.com hanya dapat diakses melalui port 14000 dan 14400.
-Tambah command ini dibawah virtualhost:80
```
<VirtualHost *:14400>
    ServerName mylta.it30.com
    ServerAlias www.mylta.it30.com

    <Proxy balancer://myita_balancer>
        BalancerMember http://MyIta:14400
    </Proxy>

    ProxyPass / balancer://myita_balancer/
    ProxyPassReverse / balancer://myita_balancer/
</VirtualHost>
```
![miga](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-07%20154917.png)
### SOAL 18
>Apa bila ada yang mencoba mengakses IP mylta akan secara otomatis dialihkan ke www.mylta.xxx.com
-Tambah kebagian virtualhost:80
```
    RewriteCond %{HTTP_HOST} ^192\.248\.2\.5$
    RewriteRule ^(.*)$ http://www.mylta.it30.com/$1 [L,R=301]
```
![ayayay](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-07%20172106.png)
Hasil
![gmba4](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-08%20153307.png)

### SOAL 19
>Karena probset sudah kehabisan ide masuk ke salah satu worker buatkan akses direktori listing yang mengarah ke resource worker2
```
 DocumentRoot /etc/apache2/worker2/resource
    <Directory /etc/apache2/worker2/resource>
        Options +Indexes
        IndexOptions FancyIndexing HTMLTable NameWidth=* DescriptionWidth=*
        AllowOverride All
        Require all granted
    </Directory>
```

### SOAL 20
>Worker tersebut harus dapat di akses dengan tamat.xxx.com dengan alias www.tamat.xxx.com
-Tambah virtualhost baru untuk servername tamat
```
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
</VirtualHost>
```
![gambling5](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-08%20212730.png)
![gbaam6](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/blob/main/gambar/Screenshot%202024-05-08%20212750.png)
