# ðŸ›¡ï¸ E2FACE â€” Easy 2-Face Dual WAN Load Balancer

![Version](https://img.shields.io/badge/Version-1.3.0-blue)
![OpenWRT](https://img.shields.io/badge/OpenWRT-18.06%2B-green)
![License](https://img.shields.io/badge/License-MIT-orange)
![Status](https://img.shields.io/badge/Status-Stable-success)

> **E2FACE** adalah skrip universal untuk konfigurasi **Dual WAN Load Balancing** di **OpenWRT** dengan tampilan interaktif, aman, dan ramah pengguna â€” tanpa mengganggu konfigurasi jaringan yang sudah ada.

---

## âœ¨ Fitur Utama

### ðŸ›¡ï¸ Safety First
- **Anti Double Configuration** â€” Deteksi dan cegah konfigurasi duplikat.  
- **Safe Interface Detection** â€” Tidak memodifikasi interface non-E2FACE.  
- **Selective Modification** â€” Hanya ubah bagian khusus E2FACE.  
- **Auto Backup & Rollback** â€” Backup otomatis dan rollback cepat.  

### âš¡ Smart Automation
- **Auto Interface Detection** â€” Deteksi otomatis interface aktif.  
- **Smart Load Balancing** â€” Rasio 1:1 dengan failover otomatis.  
- **Health Monitoring** â€” Pemantauan koneksi real-time.  
- **Auto Update** â€” Pembaruan langsung dari GitHub.  

### ðŸŽ¨ User Experience
- **Interactive Terminal Menu** â€” Navigasi mudah dan intuitif.  
- **Visual Progress & Spinner** â€” Animasi status yang menarik.  
- **Bash Completion Support** â€” Auto-complete untuk semua command.  
- **Universal Access** â€” Dapat dijalankan dari mana pun di sistem.  

---

## ðŸš€ Instalasi Cepat (30 Detik)

```bash
wget -q https://raw.githubusercontent.com/InetByOu/e2face/main/setup.sh
chmod +x setup.sh
./setup.sh
```

---

## ðŸ§  Penggunaan Dasar

### ðŸ”¹ Auto Setup (disarankan)
```bash
e2face --auto
```

### ðŸ”¹ Manual Setup
```bash
e2face --manual
```

### ðŸ”¹ Mode Interaktif
```bash
e2face
```

---

## ðŸ§© Persyaratan Sistem

| Komponen | Minimum | Rekomendasi |
|-----------|----------|-------------|
| **OpenWRT** | 18.06+ | 21.02+ |
| **RAM** | 32 MB | 64 MB+ |
| **Storage** | 2 MB bebas | 5 MB+ bebas |
| **Interfaces** | 2 fisik | 2+ fisik |

---

## ðŸ› ï¸ Metode Instalasi Lain

### 1ï¸âƒ£ Auto Installer (Direkomendasikan)
```bash
wget https://raw.githubusercontent.com/InetByOu/e2face/main/setup.sh
chmod +x setup.sh
./setup.sh
```

### 2ï¸âƒ£ Git Clone Manual
```bash
git clone https://github.com/InetByOu/e2face.git
cd e2face
chmod +x setup.sh
./setup.sh
```

### 3ï¸âƒ£ Direct Download
```bash
wget -O /usr/bin/e2face https://raw.githubusercontent.com/InetByOu/e2face/main/e2face
chmod +x /usr/bin/e2face
ln -s /usr/bin/e2face /usr/local/bin/e2face
```

---

## ðŸŽ® Menu Utama

| No | Menu | Fungsi |
|----|------|---------|
| 1 | Show Current Status | Menampilkan status sistem & load balancing |
| 2 | Auto Setup Dual WAN | Setup otomatis dua WAN |
| 3 | Manual Setup Dual WAN | Pilih interface secara manual |
| 4 | Test Configuration | Uji konfigurasi aktif |
| 5 | Show Interface Info | Tampilkan detail interface |
| 6 | Check for Updates | Periksa dan update script |
| 7 | Exit | Keluar dari program |

---

## âš™ï¸ Opsi Command Line

```bash
e2face --auto          # Setup otomatis
e2face --manual        # Setup manual
e2face eth0.2 eth0.3   # Setup cepat dua interface
e2face --status        # Status sistem
e2face --test          # Test konfigurasi aktif
e2face --interfaces    # Daftar interface
e2face --update        # Update script
e2face --help          # Bantuan
```

---

## ðŸ§° Detail Konfigurasi

### ðŸ”¸ Network Configuration
```bash
config interface 'wan1'
    option proto 'dhcp'
    option device 'eth0.2'
    option metric '10'

config interface 'wan2'
    option proto 'dhcp'
    option device 'eth0.3'
    option metric '20'
```

### ðŸ”¸ Firewall Configuration
```bash
config zone
    option name 'wan'
    list network 'wan1'
    list network 'wan2'
    option input 'REJECT'
    option output 'ACCEPT'
    option forward 'REJECT'
    option masq '1'
    option mtu_fix '1'
```

### ðŸ”¸ Load Balancing (MWAN3)
- **Rasio**: 1:1 balanced  
- **Health Check**: `8.8.8.8` dan `1.1.1.1`  
- **Failover**: Otomatis jika salah satu down  
- **Monitoring**: Real-time status  

---

## ðŸ“Š Monitoring & Maintenance

### ðŸ”¹ Status
```bash
e2face --status
mwan3 status
```

### ðŸ”¹ Log
```bash
logread | grep mwan3
```

### ðŸ”¹ Test Interface
```bash
ping -I eth0.2 8.8.8.8
ping -I eth0.3 8.8.8.8
```

### ðŸ”¹ Update
```bash
e2face --update
```

---

## ðŸ§© Sistem Keamanan

### âœ… Dilakukan
- Backup otomatis sebelum modifikasi  
- Modifikasi hanya pada `wan1` dan `wan2`  
- Rollback cepat via `/root/rollback_dualwan.sh`

### âŒ Tidak Dilakukan
- Tidak menghapus interface existing  
- Tidak mengubah konfigurasi `wan`/`lan` asli  
- Tidak menghapus zone firewall lama  

---

## ðŸ§¯ Troubleshooting

| Masalah | Pesan | Solusi |
|----------|--------|--------|
| Interface Not Found | `No physical interfaces detected!` | Cek kabel & port (`ip link show`) |
| Package Installation Failed | `Failed to install mwan3` | Jalankan `opkg update && opkg install mwan3` |
| Interface Already Used | `Interface eth0.2 is already used` | Jalankan `e2face --manual` |
| No Internet Connection | `No connectivity via eth0.2` | Cek DHCP & ping manual |

### ðŸ” Debug Commands
```bash
mwan3 status
ip route show table all
logread | grep mwan3
curl --interface wan1 http://ifconfig.me
curl --interface wan2 http://ifconfig.me
```

---

## ðŸ”„ Riwayat Versi

| Versi | Fitur Utama |
|--------|--------------|
| **v1.3.0** | ðŸ›¡ï¸ Anti Double Config Â· ðŸ” Smart Conflict Detect Â· ðŸ’¾ Selective Backup |
| **v1.2.0** | ðŸ”„ Auto Update Â· âŒ¨ï¸ Bash Completion Â· ðŸ§¹ Cleanup |
| **v1.1.0** | ðŸŽ¨ Interactive Menu Â· âš¡ Visual Progress Â· ðŸ“Š Enhanced Testing |
| **v1.0.0** | âœ… Basic Dual WAN Â· ðŸ”§ Auto Detect Â· ðŸ“ Backup System |

---

## ðŸ¤ Kontribusi

1. Fork repository  
2. Buat branch fitur:  
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. Commit perubahan:  
   ```bash
   git commit -m "Add AmazingFeature"
   ```
4. Push dan buat Pull Request  

---

## ðŸ“ Lisensi

Distribusi di bawah lisensi **MIT License**.  
Lihat file [`LICENSE`](LICENSE) untuk informasi lengkap.

---

## ðŸ‘¥ Pengembang

- **Ou** â€” *Founder & Developer* (InetByOu)  

### ðŸ™ Ucapan Terima Kasih
- Komunitas **OpenWRT**  
- Tim **MWAN3 Developers**  
- Semua **tester dan kontributor**

---

## ðŸ“ž Dukungan

1. Cek bagian *Troubleshooting* di atas  
2. Buka *GitHub Issues* untuk melaporkan bug  
3. Sertakan output dari:
   ```bash
   e2face --status
   ```

---

<div align="center">

### ðŸ›¡ï¸ E2FACE â€” Making Dual WAN Load Balancing Safe & Easy ðŸš€  
> â€œDua Internet, Satu Router, Zero Headache.â€

</div>
