# Lapres-Jarkom-Modul-1-IT30-2024

## Anggota

| Nama                            | NRP          |
| ------------------------------- | ------------ |
| Gabriella Erlinda Wijaya        | `5027221018` |
| Aras Rizky Ananta               | `5027221053` |


## SOAL 1
Untuk membantu pertempuran di Erangel, kamu ditugaskan untuk membuat jaringan komputer yang akan digunakan sebagai alat komunikasi. Sesuaikan rancangan Topologi dengan rancangan dan pembagian yang berada di link yang telah disediakan, dengan ketentuan nodenya sebagai berikut :
- DNS Master akan diberi nama `Pochinki`, sesuai dengan kota tempat dibuatnya server tersebut
- Karena ada kemungkinan musuh akan mencoba menyerang Server Utama, maka buatlah DNS Slave `Georgopol` yang mengarah ke Pochinki
- Markas pusat juga meminta dibuatkan tiga Web Server yaitu `Severny, Stalber, dan Lipovka`. Sedangkan `Mylta` akan bertindak sebagai Load Balancer untuk server-server tersebut

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


## SOAL 2
Karena para pasukan membutuhkan koordinasi untuk mengambil airdrop, maka buatlah sebuah domain yang mengarah ke Stalber dengan alamat airdrop.xxxx.com dengan alias www.airdrop.xxxx.com dimana xxxx merupakan kode kelompok. Contoh : airdrop.it30.com

Pada Pochinki jalankan command `apt-get update` lalu `apt-get install bind9 -y` untuk install bind9.
#### Pembuatan Domain
Lakukan command berikut pada Pochinki
`nano /etc/bind/named.conf.local`
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

Buka file airdrop.it30.com dan edit seperti ini
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/bb33aa70-541a-4907-80d6-4142133f01c6)

Restart bind9 dengan `service bind9 restart`

## SOAL 3
#### Pembuatan Domain
Lakukan command berikut pada Pochinki
`nano /etc/bind/named.conf.local`

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

Buka file redzone.it30.com dan edit seperti ini
![image](https://github.com/GabriellaErlinda/Jarkom-Modul-2-IT30-2024/assets/128443451/0800e8c4-dd0c-45e2-98bf-d7722edfb9a5)

Restart bind9 dengan `service bind9 restart`

## SOAL 4
#### Pembuatan Domain
Lakukan command berikut pada Pochinki
`nano /etc/bind/named.conf.local`

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

Buka file loot.it30.com dan edit seperti ini
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
