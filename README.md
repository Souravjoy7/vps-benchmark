# VPS Benchmark Script

A lightweight and automated Bash script to benchmark your VPS performance, including:

- 🧠 Memory speed
- 💾 Disk write speed
- 🔁 Memory copy speed
- 🔢 Disk IOPS (random read/write)
- ⚖️ Performance verdicts: Excellent / Good / Average / Poor

---

## 📦 Features

✅ Measures and rates:
- Disk Write Speed using `dd`  
- RAM Performance using `sysbench`  
- Memory Copy Speed using `mbw`  
- Disk IOPS using `fio`

✅ Intelligent verdicts for each test (e.g., `Excellent (NVMe VPS)`, `Average`, etc.)

✅ Automatically installs all required tools if missing

---

## 🚀 How to Use

### 1. Clone or download the script

```bash
bash <(curl -Ls https://raw.githubusercontent.com/souravjoy7/vps-benchmark/main/install.sh)
```

### 2. Uninstall The Script 
```bash
bash <(curl -Ls https://raw.githubusercontent.com/souravjoy7/vps-benchmark/main/install.sh) --uninstall



