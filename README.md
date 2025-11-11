# 🛡️ E2FACE — Easy 2-Face Dual WAN Load Balancer

![Version](https://img.shields.io/badge/Version-1.3.0-blue)
![OpenWRT](https://img.shields.io/badge/OpenWRT-18.06%2B-green)
![License](https://img.shields.io/badge/License-MIT-orange)
![Status](https://img.shields.io/badge/Status-Stable-success)

> **E2FACE** adalah skrip universal untuk konfigurasi **Dual WAN Load Balancing** di **OpenWRT** dengan tampilan interaktif, aman, dan ramah pengguna — tanpa mengganggu konfigurasi jaringan yang sudah ada.

---

## ✨ Fitur Utama

### 🛡️ Safety First
- **Anti Double Configuration** — Deteksi dan cegah konfigurasi duplikat.  
- **Safe Interface Detection** — Tidak memodifikasi interface non-E2FACE.  
- **Selective Modification** — Hanya ubah bagian khusus E2FACE.  
- **Auto Backup & Rollback** — Backup otomatis dan rollback cepat.  

### ⚡ Smart Automation
- **Auto Interface Detection** — Deteksi otomatis interface aktif.  
- **Smart Load Balancing** — Rasio 1:1 dengan failover otomatis.  
- **Health Monitoring** — Pemantauan koneksi real-time.  
- **Auto Update** — Pembaruan langsung dari GitHub.  

### 🎨 User Experience
- **Interactive Terminal Menu** — Navigasi mudah dan intuitif.  
- **Visual Progress & Spinner** — Animasi status yang menarik.  
- **Bash Completion Support** — Auto-complete untuk semua command.  
- **Universal Access** — Dapat dijalankan dari mana pun di sistem.  

---

## 🚀 Instalasi Cepat (30 Detik)

```bash
wget -q https://raw.githubusercontent.com/InetByOu/e2face/main/setup.sh
chmod +x setup.sh
./setup.sh
```

---

## 🧠 Penggunaan Dasar

### 🔹 Auto Setup (disarankan)
```bash
e2face --auto
```

### 🔹 Manual Setup
```bash
e2face --manual
```

### 🔹 Mode Interaktif
```bash
e2face
```

---

## 🧩 Persyaratan Sistem

| Komponen | Minimum | Rekomendasi |
|-----------|----------|-------------|
| **OpenWRT** | 18.06+ | 21.02+ |
| **RAM** | 32 MB | 64 MB+ |
| **Storage** | 2 MB bebas | 5 MB+ bebas |
| **Interfaces** | 2 fisik | 2+ fisik |

---

## 🛠️ Metode Instalasi Lain

### 1️⃣ Auto Installer (Direkomendasikan)
```bash
wget https://raw.githubusercontent.com/InetByOu/e2face/main/setup.sh
chmod +x setup.sh
./setup.sh
```

### 2️⃣ Git Clone Manual
```bash
git clone https://github.com/InetByOu/e2face.git
cd e2face
chmod +x setup.sh
./setup.sh
```

### 3️⃣ Direct Download
```bash
wget -O /usr/bin/e2face https://raw.githubusercontent.com/InetByOu/e2face/main/e2face
chmod +x /usr/bin/e2face
ln -s /usr/bin/e2face /usr/local/bin/e2face
```

---

## 🎮 Menu Utama

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

## ⚙️ Opsi Command Line

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

## 🧰 Detail Konfigurasi

### 🔸 Network Configuration
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

### 🔸 Firewall Configuration
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

### 🔸 Load Balancing (MWAN3)
- **Rasio**: 1:1 balanced  
- **Health Check**: `8.8.8.8` dan `1.1.1.1`  
- **Failover**: Otomatis jika salah satu down  
- **Monitoring**: Real-time status  

---

## 📊 Monitoring & Maintenance

### 🔹 Status
```bash
e2face --status
mwan3 status
```

### 🔹 Log
```bash
logread | grep mwan3
```

### 🔹 Test Interface
```bash
ping -I eth0.2 8.8.8.8
ping -I eth0.3 8.8.8.8
```

### 🔹 Update
```bash
e2face --update
```

---

## 🧩 Sistem Keamanan

### ✅ Dilakukan
- Backup otomatis sebelum modifikasi  
- Modifikasi hanya pada `wan1` dan `wan2`  
- Rollback cepat via `/root/rollback_dualwan.sh`

### ❌ Tidak Dilakukan
- Tidak menghapus interface existing  
- Tidak mengubah konfigurasi `wan`/`lan` asli  
- Tidak menghapus zone firewall lama  

---

## 🧯 Troubleshooting

| Masalah | Pesan | Solusi |
|----------|--------|--------|
| Interface Not Found | `No physical interfaces detected!` | Cek kabel & port (`ip link show`) |
| Package Installation Failed | `Failed to install mwan3` | Jalankan `opkg update && opkg install mwan3` |
| Interface Already Used | `Interface eth0.2 is already used` | Jalankan `e2face --manual` |
| No Internet Connection | `No connectivity via eth0.2` | Cek DHCP & ping manual |

### 🔍 Debug Commands
```bash
mwan3 status
ip route show table all
logread | grep mwan3
curl --interface wan1 http://ifconfig.me
curl --interface wan2 http://ifconfig.me
```

---

## 🔄 Riwayat Versi

| Versi | Fitur Utama |
|--------|--------------|
| **v1.3.0** | 🛡️ Anti Double Config · 🔍 Smart Conflict Detect · 💾 Selective Backup |
| **v1.2.0** | 🔄 Auto Update · ⌨️ Bash Completion · 🧹 Cleanup |
| **v1.1.0** | 🎨 Interactive Menu · ⚡ Visual Progress · 📊 Enhanced Testing |
| **v1.0.0** | ✅ Basic Dual WAN · 🔧 Auto Detect · 📝 Backup System |

---

## 🤝 Kontribusi

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

## 📝 Lisensi

Distribusi di bawah lisensi **MIT License**.  
Lihat file [`LICENSE`](LICENSE) untuk informasi lengkap.

---

## 👥 Pengembang

- **Edoll** — *Founder & Developer* (InetByOu)  

### 🙏 Ucapan Terima Kasih
- Komunitas **OpenWRT**  
- Tim **MWAN3 Developers**  
- Semua **tester dan kontributor**

---

## 📞 Dukungan

1. Cek bagian *Troubleshooting* di atas  
2. Buka *GitHub Issues* untuk melaporkan bug  
3. Sertakan output dari:
   ```bash
   e2face --status
   ```

---

<div align="center">

### 🛡️ E2FACE — Making Dual WAN Load Balancing Safe & Easy 🚀  
> “Dua Internet, Satu Router, Zero Headache.”

</div>
