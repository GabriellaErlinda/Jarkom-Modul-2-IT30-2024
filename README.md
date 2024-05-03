# Lapres-Jarkom-Modul-1-IT30-2024

## Anggota

| Nama                            | NRP          |
| ------------------------------- | ------------ |
| Gabriella Erlinda Wijaya        | `5027221018` |
| Aras Rizky Ananta               | `5027221053` |


## Soal 1
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

Ketikkan command ini di setiap node yang lain echo nameserver `[IP DNS] > /etc/resolv.conf`. Pada kasus ini maka command-nya adalah `echo nameserver 192.168.122.1 > /etc/resolv.conf`.
