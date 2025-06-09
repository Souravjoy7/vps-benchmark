#!/bin/bash

export LC_ALL=C

echo -e "\n=== VPS Benchmark Script ===\n"

# Install dependencies
echo -e "[*] Installing required packages (sysbench, fio, mbw, bc, jq)...\n"
apt-get update -qq
apt-get install -y sysbench fio mbw bc jq -qq

# --- Disk Write Speed (dd) ---
echo -e "\n--- Disk Write Speed (dd) ---"
dd_result=$(dd if=/dev/zero of=dd_test bs=1G count=1 oflag=dsync 2>&1)
echo "$dd_result"
rm -f dd_test

dd_speed=$(echo "$dd_result" | grep -Eo '[0-9.]+ (GB|MB)/s' | awk '{print $1}')
dd_unit=$(echo "$dd_result" | grep -Eo '[0-9.]+ (GB|MB)/s' | awk '{print $2}')

if [[ "$dd_unit" == "GB/s" ]]; then
  if (( $(echo "$dd_speed > 1.0" | bc -l) )); then verdict="Excellent (NVMe VPS)"
  elif (( $(echo "$dd_speed > 0.5" | bc -l) )); then verdict="Good (SSD VPS)"
  elif (( $(echo "$dd_speed > 0.2" | bc -l) )); then verdict="Average"
  else verdict="Poor"; fi
else
  if (( $(echo "$dd_speed > 1000" | bc -l) )); then verdict="Excellent (NVMe VPS)"
  elif (( $(echo "$dd_speed > 500" | bc -l) )); then verdict="Good (SSD VPS)"
  elif (( $(echo "$dd_speed > 200" | bc -l) )); then verdict="Average"
  else verdict="Poor"; fi
fi
echo "Verdict: Disk write speed is $verdict"

# --- Memory Benchmark (sysbench) ---
echo -e "\n--- Memory Benchmark (sysbench) ---"
mem_result=$(sysbench memory --memory-total-size=1G run)
echo "$mem_result" | grep "transferred"
mem_speed=$(echo "$mem_result" | awk '/transferred/ {gsub(/[^0-9.]/,"",$(NF-1)); print $(NF-1)}')

if (( $(echo "$mem_speed > 25000" | bc -l) )); then verdict="Excellent (Modern VPS)"
elif (( $(echo "$mem_speed > 12000" | bc -l) )); then verdict="Good"
elif (( $(echo "$mem_speed > 6000" | bc -l) )); then verdict="Average"
else verdict="Poor"; fi
echo "Verdict: RAM speed is $verdict"

# --- Memory Copy Speed (mbw) ---
echo -e "\n--- Memory Copy Speed (mbw) ---"
mbw_result=$(mbw -n 1 100 | grep "AVG" | grep "MEMCPY")
echo "$mbw_result"
mbw_speed=$(echo "$mbw_result" | awk '{print $(NF-1)}')

if (( $(echo "$mbw_speed > 15000" | bc -l) )); then verdict="Excellent (Modern VPS)"
elif (( $(echo "$mbw_speed > 7000" | bc -l) )); then verdict="Good"
elif (( $(echo "$mbw_speed > 3500" | bc -l) )); then verdict="Average"
else verdict="Poor"; fi
echo "Verdict: Memory copy speed is $verdict"

# --- Disk IOPS (fio) ---
echo -e "\n--- Disk IOPS (fio, 4k random read/write) ---"
fio --name=test --ioengine=libaio --rw=randrw --bs=4k --direct=1 --size=256M --numjobs=1 --runtime=10 --group_reporting --output-format=json > /tmp/fio.out
read_iops=$(jq -r '.jobs[0].read.iops' /tmp/fio.out)
write_iops=$(jq -r '.jobs[0].write.iops' /tmp/fio.out)
avg_iops=$(echo "($read_iops + $write_iops)/2" | bc)

echo "READ IOPS:  $read_iops"
echo "WRITE IOPS: $write_iops"

if (( $(echo "$avg_iops > 25000" | bc -l) )); then verdict="Excellent (NVMe VPS)"
elif (( $(echo "$avg_iops > 10000" | bc -l) )); then verdict="Good (SSD VPS)"
elif (( $(echo "$avg_iops > 2000" | bc -l) )); then verdict="Average"
else verdict="Poor"; fi
echo "Verdict: Disk IOPS is $verdict"
rm -f /tmp/fio.out

echo -e "\n✅ Benchmark completed."
