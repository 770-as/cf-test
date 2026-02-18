echo "AUDIT"
echo "---  SLIRP4NETNS FRAGMENTATION TEST ---"

# 1. Test the MTU limit (65520 - 28 bytes for ICMP/IP headers = 64492)
ping -s 64492 -c 1 1.1.1.1 || echo "Standard Jumbo failed"

# 2. Try to exceed the MTU to see if slirp handles the error or crashes
# We use -M want to force fragmentation and see if the 'slirp' process spikes
ping -s 65507 -c 3 1.1.1.1 &
sleep 1
ps aux | grep slirp4netns
curl -I http://google.com || echo "Outbound blocked"

echo "--- FINISHED ---"
